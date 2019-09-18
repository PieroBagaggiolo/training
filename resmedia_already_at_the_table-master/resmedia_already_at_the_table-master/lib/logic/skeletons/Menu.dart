import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/RestaurantRepository.dart';
import 'package:resmedia_already_at_the_table/model/menu_model.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/products/ProductModel.dart';
import 'package:rxdart/rxdart.dart';

class DrinkMenuSkeleton extends SkeletonValues<DrinkModel> implements MenuBone<DrinkCategory> {
  DrinkMenuSkeleton() : super() {
    _outMenus = Observable(outValue.map((products) {
      final raw = categorized(DrinkCategory.values, products, (product) => product.category);
      return raw.keys.map((category) {
        return MenuModel<DrinkCategory>(category: category, products: raw[category]);
      }).toList();
    })).shareValue();
  }

  @override
  AsyncValueSetter<ProductModel> onTapProduct;

  ValueObservable<List<MenuModel<DrinkCategory>>> _outMenus;
  @override
  ValueObservable<List<MenuModel<DrinkCategory>>> get outMenus => _outMenus;
}

class FoodMenuSkeleton extends SkeletonValues<FoodModel> implements MenuBone<FoodCategory> {
  FoodMenuSkeleton() : super() {
    _outMenus = Observable(outValue.map((products) {
      final raw = categorized(FoodCategory.values, products, (product) => product.category);
      return raw.keys.map((category) {
        return MenuModel<FoodCategory>(category: category, products: raw[category]);
      }).toList();
    })).shareValue();
  }

  @override
  AsyncValueSetter<ProductModel> onTapProduct;

  ValueObservable<List<MenuModel<FoodCategory>>> _outMenus;
  @override
  ValueObservable<List<MenuModel<FoodCategory>>> get outMenus => _outMenus;
}

abstract class MenuBone<C> extends Bone {
  AsyncValueSetter<ProductModel> get onTapProduct;

  ValueObservable<List<MenuModel<C>>> get outMenus;
}
