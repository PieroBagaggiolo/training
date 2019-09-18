import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/Booking.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/Menu.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';
import 'package:resmedia_already_at_the_table/model/menu_model.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantBloc extends BlocBase {
  final repository = RepositoryBloc.of();

  final Pocket _pocket = Pocket();

  @protected
  dispose() {
    _restaurantController.close();
    _bookingSkeleton.dispose();
    _foodMenuSkeleton.dispose();
    _drinksSkeleton.dispose();
    _eventController.close();
    super.dispose();
  }

  final BehaviorSubject<RestaurantModel> _restaurantController;
  Stream<RestaurantModel> get outRestaurant => _restaurantController;
  RestaurantModel get restaurant => _restaurantController.value;

  final BookingSkeleton _bookingSkeleton;
  BookingBone get bookingBone => _bookingSkeleton;

  final FoodMenuSkeleton _foodMenuSkeleton = FoodMenuSkeleton();
  MenuBone get foodMenuBone => _foodMenuSkeleton;

  Stream<Data2<RestaurantModel, List<MenuModel<FoodCategory>>>> outRestaurantAndMenus;

  final DrinkMenuSkeleton _drinksSkeleton = DrinkMenuSkeleton();
  MenuBone get drinkBone => _drinksSkeleton;

  final PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController.stream;

  bool isInit = false;
  RestaurantBloc({
    @required RestaurantModel seedValue,
    @required UserModel user,
  })  : _restaurantController = BehaviorSubject.seeded(seedValue),
        this._bookingSkeleton = BookingSkeleton(user: user, restaurant: seedValue) {
    final restaurantDc = RestaurantDc(seedValue.reference);

    _pocket.putAndGet(_restaurantController).pipeSource(() => restaurantDc.outer());

    _foodMenuSkeleton.pocket.pipeSource(() => restaurantDc.foods().outer());
    _foodMenuSkeleton.onTapProduct = (product) async {
      _eventController.add(TapFoodEvent(product));
    };

    _drinksSkeleton.pocket.pipeSource(() => restaurantDc.drinks().outer());

    outRestaurantAndMenus =
        Observable.combineLatest2(outRestaurant, foodMenuBone.outMenus, (restaurant, menu) {
      return restaurant == null
          ? null
          : Data2<RestaurantModel, List<MenuModel<FoodCategory>>>(restaurant, menu);
    }).shareValueSeeded(restaurant == null ? null : Data2(restaurant, foodMenuBone.outMenus.value));
  }
  factory RestaurantBloc.of() => BlocProvider.of<RestaurantBloc>();
  factory RestaurantBloc.init(RestaurantBloc bloc) => BlocProvider.init(bloc);
  static void close() => BlocProvider.dispose<RestaurantBloc>();
}

class TapFoodEvent {
  final FoodModel product;

  TapFoodEvent(this.product);
}
