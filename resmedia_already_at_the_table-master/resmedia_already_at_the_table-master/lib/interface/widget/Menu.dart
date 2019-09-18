import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_already_at_the_table/generated/i18nMethod.dart';
import 'package:resmedia_already_at_the_table/interface/view/ProductView.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/Menu.dart';
import 'package:resmedia_already_at_the_table/model/menu_model.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/products/ProductModel.dart';

class NextTabButton extends StatelessWidget {
  const NextTabButton();

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => DefaultTabController.of(context).index += 1,
      child: FittedText("Continua"),
    );
  }
}

class BackTabButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => DefaultTabController.of(context).index -= 1,
      child: FittedText("Retrocedi"),
    );
  }
}

class SliverBottomMenu extends StatelessWidget {
  final Widget left, right;

  const SliverBottomMenu({Key key, @required this.left, @required this.right}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: <Widget>[
            Expanded(child: left),
            const SizedBox(
              width: 16.0,
            ),
            Expanded(child: right),
          ],
        ),
      ),
    );
  }
}

class Menu<C> extends StatelessWidget {
  final MenuBone bone;
  final C category;
  final List<ProductModel> products;

  const Menu({
    Key key,
    this.bone,
    @required this.category,
    @required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverStickyHeader(
      header: Container(
        color: theme.canvasColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 8.0),
              child: Text(
                category is FoodCategory
                    ? SS.foodCategoryToMenuTitle(category as FoodCategory)
                    : (category is DrinkCategory
                        ? translateDrinkCategory(category as DrinkCategory)
                        : ""),
                style: theme.textTheme.title.copyWith(color: Colors.black),
              ),
            ),
            Container(
              color: theme.primaryColor,
              height: 2.0,
            )
          ],
        ),
      ),
      sliver: SliverListLayout.childrenBuilder(
        builder: (_, index) {
          final product = products[index];

          return InkWell(
            onTap: () => BoneProvider.of<MenuBone<C>>(context, false).onTapProduct(product),
            child: ProductView(
              model: product,
            ),
          );
        },
        childCount: products.length,
        separator: const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Divider(height: 0.0),
        ),
      ),
    );
  }

  static List<Widget> toList<C>({
    @required List<MenuModel> menus,
  }) {
    return menus.map((menu) {
      return Menu<C>(
        category: menu.category,
        products: menu.products,
      );
    }).toList();
  }
}

class SliverMenu extends StatelessWidget {
  final Widget title;
  final int childCount;
  final IndexedWidgetBuilder builder;

  const SliverMenu({
    Key key,
    @required this.title,
    @required this.childCount,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverStickyHeader(
      header: Container(
        color: theme.canvasColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 8.0),
              child: DefaultTextStyle(
                child: title,
                style: theme.textTheme.title.copyWith(color: Colors.black),
              ),
            ),
            Container(
              color: theme.primaryColor,
              height: 2.0,
            )
          ],
        ),
      ),
      sliver: SliverListLayout.childrenBuilder(
        builder: builder,
        childCount: childCount,
        separator: const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Divider(height: 0.0),
        ),
      ),
    );
  }

  static List<Widget> toList<C>({
    @required List<MenuModel> menus,
  }) {
    return menus.map((menu) {
      return Menu<C>(
        category: menu.category,
        products: menu.products,
      );
    }).toList();
  }

//  static Widget toCustomScrollView({@required MenuBone bone}) {
//    return ObservableBuilder<Map<dynamic, List>>((_, categorizedProducts, state) {
//      if (state is WaitingState) {
//        return state.toWidget();
//      }
//
//      return CustomScrollView(
//        slivers: Menu.toList(
//          menus: categorizedProducts,
//        ),
//      );
//    }, stream: bone.outMenu,);
//  }
}

class MenuWidget extends StatelessWidget {
  final Widget title;
  final int childCount;
  final IndexedWidgetBuilder childrenBuilder;

  const MenuWidget({
    Key key,
    @required this.title,
    @required this.childCount,
    @required this.childrenBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverStickyHeader(
      header: Container(
        color: theme.canvasColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 8.0),
              child: DefaultTextStyle(
                child: title,
                style: theme.textTheme.title.copyWith(color: Colors.black),
              ),
            ),
            Container(
              color: theme.primaryColor,
              height: 2.0,
            )
          ],
        ),
      ),
      sliver: SliverListLayout.childrenBuilder(
        builder: childrenBuilder,
        childCount: childCount,
        separator: const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: const Divider(height: 0.0),
        ),
      ),
    );
  }
}

class MenuView<C> extends StatelessWidget {
  final MenuModel<C> menu;
  final ValueTapper<ProductModel> onTapProduct;

  const MenuView({Key key, @required this.menu, @required this.onTapProduct}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final category = menu.category;

    return MenuWidget(
      title: Text(category is FoodCategory ? SS.foodCategoryToMenuTitle(category) : null),
      childCount: menu.products.length,
      childrenBuilder: (_, index) {
        final product = menu.products[index];

        return InkWell(
          onTap: () => onTapProduct(context, product),
          child: ProductView(
            model: product,
          ),
        );
      },
    );
  }
}

//abstract class MenuToListWidget extends StatefulWidget {
//  MenuBone get menuBone;
//}
//mixin MenuBuildMixin<WidgetType extends MenuToListWidget> on State<WidgetType> {
//  BonePocket<Map<dynamic, List>, MenuBone> _pocket;
//
//  MenuBone get menuBone => _pocket.bone;
//  Map<dynamic, List> get menu => _pocket.data;
//
//  @override
//  void initState() {
//    super.initState();
//    _pocket = BonePocket(this, (oldWidget) {
//      if (oldWidget is MenuToListWidget && oldWidget.menuBone != widget.menuBone)
//        return null;
//      return widget.menuBone;
//    }, () => menuBone.outMenu);
//  }
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _pocket.updateBone();
//  }
//
//  @override
//  void didUpdateWidget(oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    _pocket.updateBone(oldWidget);
//  }
//
//  List<Widget> buildMenu() {
//
//    return menu.keys.map((category) {
//
//      return Menu(
//        category: category,
//        products: menu[category],
//      );
//    }).toList();
//  }
//}
//
//
//
//class BonePocket<D, BoneType extends Bone> {
//
//  BonePocket(this._widgetState, this._getter, this._outer);
//
//  final State _widgetState;
//
//  final ValueToValue<BoneType, StatefulWidget> _getter;
//  final ValueGetter<Stream<D>> _outer;
//
//  BoneType _bone;
//  BoneType get bone => _bone;
//
//  StreamSubscription _subscription;
//  D _data;
//  D get data => _data;
//  Object _state;
//  Object get state => _state;
//
//  void updateBone([StatefulWidget widget]) {
//    final newMenuBone = _getter(widget)??BoneProvider.of<BoneType>(_widgetState.context);
//    assert(newMenuBone != null);
//    if (_bone == newMenuBone)
//      return;
//
//    _subscription?.cancel();
//    _bone = newMenuBone;
//    final stream = _outer();
//    _subscription = stream.listen((data) {
//      // ignore: invalid_use_of_protected_member
//      _widgetState.setState(() {
//        _data = data;
//        _state = null;
//      });
//    }, onError: (error) {
//      // ignore: invalid_use_of_protected_member
//      _widgetState.setState(() {
//        _state = error;
//        _data = null;
//      });
//    });
//    _data = stream is ValueObservable ? (stream as ValueObservable).value : null;
//    _state = null;
//  }
//}

//mixin _MenuBuildMixin<WidgetType extends MenuToListWidget> on BonePocketMixin<WidgetType> {
//  MenuBone get menuBone => data<MenuBone>();
//  Map<dynamic, List> get menu => _pocket.data;
//
//  @override
//  void initState() {
//    super.initState();
//    initPocket(BonePocket(this, (oldWidget) {
//      if (oldWidget is MenuToListWidget && oldWidget.menuBone != widget.menuBone)
//        return null;
//      return widget.menuBone;
//    }, () => menuBone.outMenu));
//  }
//
//  List<Widget> buildMenu() {
//
//    return menu.keys.map((category) {
//
//      return Menu(
//        category: category,
//        products: menu[category],
//        onTapProduct: menuBone.inProductOfMenu,
//      );
//    }).toList();
//  }
//}
//
//mixin BonePocketMixin<WidgetType extends MenuToListWidget> on State<WidgetType> {
//  HashMap<Type, BonePocket> _pockets = HashMap();
//
//  void initPocket<D, BoneType extends Bone>(BonePocket<D, BoneType> pocket) => _pockets[D] = pocket;
//
//  B
//  D data<D>() => _pockets[D].data is D ? _pockets[D].data : null;
//
//  @override
//  void didChangeDependencies() {
//    super.didChangeDependencies();
//    _pockets.values.forEach((pocket) => pocket.updateBone());
//  }
//  @override
//  void didUpdateWidget(oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    _pockets.values.forEach((pocket) => pocket.updateBone(oldWidget));
//  }
//}

//typedef Widget ValueBuilder<V>(BuildContext context, V value);
//
//class BoneBuilder<V> extends StreamBuilder {
//  BoneBuilder({
//    @required BoneValue<V> bone,
//    Widget initializer,
//    Widget loader: loading,
//    @required ValueBuilder<V> builder,
//    ValueBuilder<Object> onError: _onError,
//  }) : this.builder(
//    bone: bone,
//    initializer: (_) => initializer??loader,
//    loader: (_) => loader,
//    builder: builder,
//    onError: onError,
//  );
//
//  BoneBuilder.builder({
//    @required BoneValue<V> bone,
//    WidgetBuilder initializer,
//    WidgetBuilder loader: loader,
//    @required ValueBuilder<V> builder,
//    ValueBuilder<Object> onError: _onError,
//  }) : assert(bone != null), assert(builder != null), super(
//    initialData: bone.value,
//    stream: bone.outValue,
//    builder: (context, snapshot) {
//      if (snapshot.hasError) {
//        return onError(context, snapshot.error);
//      }
//      if (snapshot.connectionState == ConnectionState.none) {
//        return (initializer??loader)(context);
//      }
//      if (!snapshot.hasData) {
//        return loader(context);
//      }
//      return builder(context, snapshot.data);
//    },
//  );
//
//  static const loading = const Center(
//    child: const Padding(
//      padding: const EdgeInsets.all(8.0),
//      child: const CircularProgressIndicator(),
//    ),
//  );
//  static const empty = const SizedBox(width: 16.0, height: 16.0,);
//
//  static Widget loader(BuildContext context) => loading;
//  static Widget emptier(BuildContext context) => empty;
//
//  static Widget _onError(BuildContext context, Object error) {
//    return Center(
//      child: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error,),
//      ),
//    );
//  }
//}

/*class MenuTree extends StatelessWidget {
  final MenuTreeBone bone;
  final List<Widget> topSlivers, bottomSlivers;

  const MenuTree({Key key,
    this.bone,
    this.topSlivers: const [], this.bottomSlivers: const [],
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final bone = this.bone??BoneProvider.of<MenuTreeBone>(context);

    return StreamBuilder<Map<String, List<SheetFs<ProductModel>>>>(
      initialData: bone.value,
      stream: bone.outValue,
      builder: (context, snapshot) {
        final menu = snapshot.data;

        final slivers = snapshot.hasData ? menu.keys.map((title) {
          final products = menu[title];

          return Menu(
            title: title,
            childrenDelegate: SliverChildBuilderDelegate((_, index) {
              final product = products[index];

              return InkWell(
                onTap: () => bone.inProductID(product.id),
                child: ProductView(
                  model: product.model,
                ),
              );
            },
            ),
          );
        }).toList() : const [];

        return CustomScrollView(
          slivers: <Widget>[
            ...topSlivers,
            ...slivers,
            ...bottomSlivers,
          ],
        );
      },
    );
  }
}*/
