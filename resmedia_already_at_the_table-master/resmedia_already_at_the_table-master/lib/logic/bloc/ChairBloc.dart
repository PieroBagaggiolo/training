import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:rational/rational.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/RestaurantRepository.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/Menu.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:rxdart/rxdart.dart';

class ChairBloc extends SkeletonValue<ChairModel> {
//  final Pocket _pocket = Pocket();

  @override
  void dispose() {
    _foodsCartController.dispose();
    _foodsSkeleton.dispose();
    _drinksCartController.dispose();
    _drinksSkeleton.dispose();
    _eventController.close();
    super.dispose();
  }

  final CartFsController _foodsCartController = CartFsController();
  CartFsManager get foodsCartManager => _foodsCartController;
  Stream<Cart> get outFoodsCart => _foodsCartController.outCart;

  FoodMenuSkeleton _foodsSkeleton = FoodMenuSkeleton();
  MenuBone<FoodCategory> get foodBone => _foodsSkeleton;

  final CartFsController _drinksCartController = CartFsController();
  CartFsManager get drinksCartManager => _drinksCartController;
  Stream<Cart> get outDrinksCart => _drinksCartController.outCart;

  DrinkMenuSkeleton _drinksSkeleton = DrinkMenuSkeleton();
  MenuBone get drinkBone => _drinksSkeleton;

  Stream<Rational> get outTotalPrice =>
      Observable.combineLatest4<Cart, List<FoodModel>, Cart, List<DrinkModel>, Rational>(
          outFoodsCart, _foodsSkeleton.outValue, outDrinksCart, _drinksSkeleton.outValue,
          (cartFood, foods, cartDrink, drinks) {
        return cartFood.getTotalPrice(foods) + cartDrink.getTotalPrice(drinks);
      });

  Stream<int> get outCountProducts => outFoodsCart.map((cart) => cart?.countProducts);

  PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

  final bool isActiveCart;

  ChairBloc(
    ChairModel initialValue,
    String restaurantID, {
    this.isActiveCart: true,
  }) : super(initialValue) {
    pocket.pipeSource(() => ChairDc(value.reference).outer());

    final chairDc = ChairDc(initialValue.reference);

    final restaurantDc = RestaurantCl().document(restaurantID);

    _foodsCartController.setSource(
      source: () => outValue.map((chair) {
        if (chair == null) return const <ProductCart>[];
        return chair.products.foods.toList();
      }),
      updater: (productID, vd) => chairDc.updateFood(productID, vd),
    );
    _foodsSkeleton.pocket.catchSource(
        source: () => _foodsCartController.outCart,
        onData: (cart) {
          if (cart == null) return;
          _foodsSkeleton.pocket.pipeStream(restaurantDc.foods().documents(cart.idProducts));
        });
    _foodsSkeleton.onTapProduct = (product) async {
      _eventController.add(product);
    };

    _drinksCartController.setSource(
      source: () => outValue.map((chair) {
        if (chair == null) return const <ProductCart>[];
        return chair.products.drinks.toList();
      }),
      updater: (productID, vd) => chairDc.updateDrink(productID, vd),
    );

    _drinksSkeleton.pocket.catchSource<Cart>(
      source: () => _drinksCartController.outCart,
      onData: (cart) {
        if (cart == null) return;
        _drinksSkeleton.pocket.pipeStream(restaurantDc.drinks().documents(cart.idProducts));
      },
    );
  }
  static ChairBloc init(ChairBloc bloc) => BlocProvider.init(bloc);
  factory ChairBloc.of() => BlocProvider.of<ChairBloc>();
  static close() => BlocProvider.dispose<ChairBloc>();
}
