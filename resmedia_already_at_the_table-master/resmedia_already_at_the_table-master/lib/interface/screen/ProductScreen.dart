import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:resmedia_already_at_the_table/backend/text_backend.dart';
import 'package:resmedia_already_at_the_table/data/icons/res_media_icons.dart';
import 'package:resmedia_already_at_the_table/data/tmp/menu.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/interface/widget/BottonBarButton.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/FoodBloc.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/products/ProductModel.dart';

class FoodScreen extends StatefulWidget {
  static const String ROUTE = "FoodScreen";

  @override
  _FoodScreenState createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  final FoodBloc _foodBloc = FoodBloc.of();

  @override
  void dispose() {
    FoodBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    //final cls = theme.colorScheme;

    final child = ObservableBuilder<FoodModel>(
      stream: _foodBloc.outFood,
      builder: (_context, food, state) {
        if (state.isBadState) return state.toWidget();

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  titlePadding: const EdgeInsets.symmetric(horizontal: 70, vertical: 16.0),
                  title: Text(
                    "${food.title}",
                    style: tt.title.copyWith(color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  background: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: Ink.image(
                          image: CachedNetworkImageProvider(
                            food.img,
                            cacheManager: CacheManager.twoDay(),
                          ),
                          fit: BoxFit.cover,
                          child: InkWell(
                            onTap: () => PocketRouter().push(
                              context,
                              FoodPhotoScreen.ROUTE,
                              builder: (_) => FoodPhotoScreen(
                                model: food,
                              ),
                              options: PocketRouteOptions(transition: Transition.material),
                            ),
                          ),
                        ),
                      ),
                      Container(height: 64, color: theme.canvasColor),
                    ],
                  ),
                ),
                titleSpacing: 16.0,
              ),
              SliverContainer.adapter(
                child: Paragraph(
                  title: Text("Descrizione"),
                  body: TextBackEnd(
                    title: "Descrizione",
                    onSave: (_) {},
                    child: Text(
                      "${foodModel.description}",
                    ),
                  ),
                ),
                padding: const EdgeInsets.all(SPACE),
              ),
              if (_foodBloc.hasCart)
                ObservableListBuilder<Data2<DrinkModel, bool>>(
                  stream: _foodBloc.outDrinkAndIsSelected,
                  builder: (_, itemBuilder, state) {
                    if (state.isBadState) return state.toSliver();

                    return SliverListLayout.childrenBuilder(
                      builder: itemBuilder,
                      separator: const Divider(),
                      surround: true,
                      childCount: state.data.length,
                    );
                  },
                  itemBuilder: (_, data, state) {
                    final drink = data.data1;
                    final isSelected = data.data2;

                    return CheckboxListTile(
                      value: isSelected,
                      title: Text("${drink.title}"),
                      onChanged: (isSelected) => _foodBloc.updateDrinkInCart(drink, isSelected),
                    );
                  },
                )
              else
                SliverListLayout.children(
                  padding: const EdgeInsets.all(SPACE),
                  separator: const SizedBox(height: 16.0),
                  children: [
                    Paragraph(
                      title: Text("Ingredienti principali"),
                      body: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Aromi"),
                          Text("Spezie"),
                        ],
                      ),
                    ),
                    Paragraph(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            ResMedia.chef,
                            size: 32,
                          ),
                          SizedBox(
                            height: SPACE / 2,
                          ),
                          Text("Ricetta"),
                        ],
                      ),
                      body: Column(
                        children: <Widget>[
                          TextBackEnd(
                            title: "Ricetta",
                            onSave: (_) {},
                            child: Text("${foodModel.recipe}"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          bottomNavigationBar: _foodBloc.hasCart
              ? _AddToCart(
                  model: food,
                )
              : null,
        );
      },
    );

    return _foodBloc.hasCart
        ? BoneProvider<CartFsManager>(
            bone: _foodBloc.foodsCartManager,
            child: child,
          )
        : child;
  }
}

class _AddToCart extends StatelessWidget {
  final CartFsManager manager;
  final ProductModel model;

  _AddToCart({
    Key key,
    this.manager,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;

    final manager = this.manager ?? BoneProvider.of<CartFsManager>(context);

    if (manager == null) return const SizedBox();

    return StreamBuilder<Cart>(
        stream: manager.outCart,
        builder: (context, snapshot) {
          final product = snapshot.data?.getProduct(model.id);
          debugPrint("Product Order: ${snapshot.data?.products}");
          debugPrint("Product ${model.id}: ${snapshot.data?.getProduct(model.id)}");
          if ((product?.countProducts ?? 0) == 0)
            return BottomBarButton(
              onPressed: () => manager.inIncrementFs(model),
              child: SizedBox(
                height: 48,
                child: NavigationToolbar(
                  middle: Text("Aggiungi al Carello"),
                  trailing: Text("5,00 €"),
                ),
              ),
            );

          return BottomBarButton(
            color: cls.secondary,
            onPressed: () => manager.inDecreaseFs(model),
            child: FittedText("Rimuovi dal Carello"),
          );
        });
  }
}

class FoodPhotoScreen extends StatelessWidget {
  static const ROUTE = "FoodPhotoScreen";

  final _foodBloc = FoodBloc.of();

  final FoodModel model;

  FoodPhotoScreen({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    //final tt = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => PocketRouter().pop(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: PhotoView(
        imageProvider: CachedNetworkImageProvider(
          model.img,
          cacheManager: CacheManager.twoDay(),
        ),
        heroAttributes: PhotoViewHeroAttributes(
          tag: model.img,
        ),
        minScale: PhotoViewComputedScale.contained,
        maxScale: 4.0,
      ),
      bottomNavigationBar: _foodBloc.hasCart
          ? _AddToCart(
              model: model,
              manager: _foodBloc.foodsCartManager,
            )
          : null,
    );
  }
}

//class DrinkScreen extends StatefulWidget implements WidgetRoute {
//  static const String ROUTE = 'DrinkScreen';
//  String get route => ROUTE;
//
//  final String path;
//
//  const DrinkScreen({Key key, @required this.path}) : super(key: key);
//
//  @override
//  _DrinkScreenState createState() => _DrinkScreenState();
//}
//
//class _DrinkScreenState extends State<DrinkScreen> {
//  DrinkBloc _drinkBloc;
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _drinkBloc = DrinkBloc.of()..initPathDrink(widget.path);
//  }
//
//  @override
//  void dispose() {
//    _drinkBloc.close();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final theme = Theme.of(context);
//    final tt = theme.textTheme;
//
//    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text("Scheda Prodotto"),
//      ),
//      body: CacheStreamBuilder<DrinkModel>(
//        stream: _drinkBloc.outDrink,
//        builder: (_context, snap) {
//          if (!snap.hasData) return const SizedBox();
//
//          final model = snap.data;
//
//          return SingleChildScrollView(
//            child: Padding(
//              padding: const EdgeInsets.all(SPACE),
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "${model.title}",
//                    style: tt.display1,
//                  ),
//                  Divider(),
//                  Align(
//                    alignment: Alignment.topRight,
//                    child: PriceView(
//                      model.price,
//                    ),
//                  ),
//                  AspectRatio(
//                    aspectRatio: 1,
//                    child: Row(
//                      children: <Widget>[
//                        AspectRatio(
//                          aspectRatio: 0.7,
//                          child: CachedNetworkImage(
//                            imageUrl: model.img,
//                            fit: BoxFit.cover,
//                            cacheManager: CacheManager.twoDay(),
//                          ),
//                        ),
//                        /*Column(
//                        children: List.generate(2, (index) => AspectRatio(
//                          aspectRatio: 1,
//                          child: Image.asset(model.img, fit: BoxFit.fill,),
//                        )),
//                      ),*/
//                      ],
//                    ),
//                  ),
//                  Divider(),
//                  Paragraph(
//                    title: Text("Descrizione"),
//                    body: TextBackEnd(
//                      title: "Descrizione",
//                      onSave: (_) {},
//                      child: Text("${model.description}"),
//                    ),
//                  ),
//                  Paragraph(
//                    title: Text("Caratteristiche"),
//                    body: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Text("Dolce"),
//                        Text("Saporito"),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          );
//        },
//      ),
//    );
//  }
//}
