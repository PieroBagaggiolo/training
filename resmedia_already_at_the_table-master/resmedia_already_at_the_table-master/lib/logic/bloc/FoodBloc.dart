import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/ChairBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:rxdart/rxdart.dart';

class FoodBloc extends BlocBase {
  final _pocket = Pocket();
  final ChairBloc _chairBloc;

  void dispose() {
    _foodController.close();
    super.dispose();
  }

  final BehaviorSubject<FoodModel> _foodController;
  Stream<FoodModel> get outFood => _foodController;

  bool get hasCart => _chairBloc != null && _chairBloc.isActiveCart;

  CartManager get foodsCartManager => _chairBloc.foodsCartManager;

  Stream<List<Data2<DrinkModel, bool>>> _outDrinkAndIsSelected;
  Stream<List<Data2<DrinkModel, bool>>> get outDrinkAndIsSelected {
    if (_outDrinkAndIsSelected == null)
      _outDrinkAndIsSelected =
          Observable.combineLatest2<List<DrinkModel>, Cart, List<Data2<DrinkModel, bool>>>(
        RestaurantDc(foodDc.reference.parent().parent()).drinks().outer(),
        _chairBloc.outDrinksCart,
        _combineDrinkAndIsSelected,
      ).shareValue();
    return _outDrinkAndIsSelected;
  }

  List<Data2<DrinkModel, bool>> _combineDrinkAndIsSelected(List<DrinkModel> drinks, Cart cart) {
    return drinks.map((drink) => Data2(drink, cart.getProduct(drink.id) != null)).toList();
  }

  final FoodDc foodDc;

  FoodBloc({
    @required FoodModel seedValue,
    @required ChairBloc chairBloc,
  })  : foodDc = FoodDc(seedValue.reference),
        _foodController = BehaviorSubject.seeded(seedValue),
        this._chairBloc = chairBloc {
    _pocket.putAndGet(_foodController).pipeSource(() => foodDc.outer());
  }

  static FoodBloc init(FoodBloc skeleton) => BlocProvider.init(skeleton);
  static FoodBloc of() => BlocProvider.of<FoodBloc>();
  static void close() => BlocProvider.dispose<FoodBloc>();

  Future<void> updateDrinkInCart(DrinkModel drink, bool newSelection) async {
    newSelection
        ? _chairBloc.drinksCartManager.inIncrementFs(drink)
        : _chairBloc.drinksCartManager.inDecreaseFs(drink);
  }
}
