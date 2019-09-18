import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/screen/CartScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/ProductScreen.dart';
import 'package:resmedia_already_at_the_table/interface/widget/BottonBarButton.dart';
import 'package:resmedia_already_at_the_table/interface/widget/Menu.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/ChairBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/FoodBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableBloc.dart';
import 'package:resmedia_already_at_the_table/model/menu_model.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/products/ProductModel.dart';

class MenuScreen extends StatefulWidget {
  static const String ROUTE = "MenuScreen";

  MenuScreen({
    Key key,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _tableBloc = TableBloc.of();

  final ChairBloc _chairBloc = ChairBloc.of();

  @override
  void initState() {
    super.initState();
    _chairBloc.outEvent.listen((event) {
      if (event is ProductModel) {
        _onTapProduct(context, event);
      }
    });
  }

  @override
  void dispose() {
    ChairBloc.close();
    super.dispose();
  }

  void _onTapProduct(BuildContext context, ProductModel product) {
    FoodBloc.init(FoodBloc(seedValue: FoodModel.product(product), chairBloc: _chairBloc));
    PocketRouter().push(context, FoodScreen.ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    //final cls = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_chairBloc.isActiveCart ? "Ordina" : "Visualizza"),
      ),
      body: ObservableBuilder<List<MenuModel<FoodCategory>>>(
        stream:
            _chairBloc.isActiveCart ? _tableBloc.foodBone.outMenus : _chairBloc.foodBone.outMenus,
        builder: (context, menus, state) {
          if (state.isBadState) return state.toWidget();
          if (menus.length == 0)
            return Alert(
              icon: const Icon(Icons.remove_shopping_cart),
              text: Text("Carello vuoto"),
            );

          return CustomScrollView(
            slivers: [
              ...menus.map((menu) {
                return MenuView<FoodCategory>(
                  menu: menu,
                  onTapProduct: _onTapProduct,
                );
              }),
            ],
          );
        },
      ),
      bottomNavigationBar: ObservableBuilder<int>(
          stream: _chairBloc.outCountProducts,
          builder: (context, countProducts, state) {
            if (state.isBadState || countProducts == 0 || !_chairBloc.isActiveCart)
              return const SizedBox();

            return BottomBarButton(
              onPressed: () => PocketRouter().push(context, CartScreen.ROUTE),
              child: Text("Vai al Carello ($countProducts)"),
            );
          }),
    );
  }
}

class CounterProduct extends StatelessWidget {
  final String idProduct;
  final Stream<Cart> stream;

  const CounterProduct({Key key, @required this.idProduct, @required this.stream})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Cart>(
      stream: stream,
      builder: (_, snap) {
        final product = snap.data?.getProduct(idProduct);

        return SizedBox(
          height: 40,
          child: StepperButton(
            child: Text('${product?.countProducts ?? 0}'),
            onIncrement: () => snap.data?.increment(idProduct),
            onDecrease: () => snap.data?.decrease(idProduct),
          ),
        );
      },
    );
  }
}
/*StreamBuilder<List<DrinkModel>>(
                stream: _tableBloc.outDrinks,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator(),);

                  return CustomScrollView(
                    slivers: [
                      ...DrinkCategory.values.map((category) {
                        final products = snapshot.data.where((drink) => drink.category == category).toList();

                        return Menu(
                          title: translateDrinkCategory(category),
                          childrenDelegate: SliverChildBuilderDelegate((_, index) {
                            final product = products[index];

                            return InkWell(
                              onTap: () => EasyRouter.push(context, DrinkScreen(
                                path: product.path,
                              )),
                              child: ProductView(
                                model: product,
                                counter: CounterProduct(
                                  idProduct: product.id,
                                  stream: _chairBloc.outDrinksCart,
                                ),
                              ),
                            );
                          },
                            childCount: products.length,
                          ),
                        );
                      }),
                      SliverBottomMenu(
                        left: backToRestaurant,
                        right: RaisedButton(
                          onPressed: () => PocketRouter().push(context, CheckOrderScreen.ROUTE),
                          child: FittedText("Paga"),
                        ),
                      ),
                    ],
                  );
                },
              ),*/
