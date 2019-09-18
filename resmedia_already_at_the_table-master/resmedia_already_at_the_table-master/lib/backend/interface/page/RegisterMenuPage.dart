import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/interface/widget/NewProductVoidOwner.dart';
import 'package:resmedia_already_at_the_table/backend/logic/blocs/RestaurantEditBloc.dart';
import 'package:resmedia_already_at_the_table/generated/i18nMethod.dart';
import 'package:resmedia_already_at_the_table/interface/view/ProductView.dart';
import 'package:resmedia_already_at_the_table/interface/widget/Menu.dart';
import 'package:resmedia_already_at_the_table/model/menu_model.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';

class MenuFoodPageViewOwner extends StatelessWidget {
  final RestaurantEditBloc _restaurantEditBloc = RestaurantEditBloc.of();

  @override
  Widget build(BuildContext context) {
    return FormProvider(
      child: BoneProviderTree(
        boneProviders: [
          BoneProvider.tree(_restaurantEditBloc.foodMenusBone),
        ],
        child: ObservableBuilder<List<MenuModel<FoodCategory>>>(
          builder: (_context, menus, state) {
            if (state.isBadState) return state.toWidget();

            return Layout.horizontal(
              children: [
                MenuEditView<FoodCategory>(
                  categories: FoodCategory.values,
                  menus: menus,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ButtonFieldShell(
                    bone: _restaurantEditBloc.foodButtonBone,
                    shape: ContinuousRectangleBorder(),
                    child: Text("Continua"),
                  ),
                ),
              ],
            );
          },
          stream: _restaurantEditBloc.foodMenusBone.outMenus,
        ),
      ),
    );
  }
}

class MenuDrinkPageViewOwner extends StatelessWidget {
  final RestaurantEditBloc _restaurantEditBloc = RestaurantEditBloc.of();

  @override
  Widget build(BuildContext context) {
    return FormProvider(
      child: BoneProviderTree(
        boneProviders: [
          BoneProvider.tree(_restaurantEditBloc.drinkMenusBone),
        ],
        child: ObservableBuilder<List<MenuModel<DrinkCategory>>>(
          builder: (_context, menus, state) {
            if (state.isBadState) return state.toWidget();

            return Layout.vertical(
              children: [
                MenuEditView<DrinkCategory>(
                  categories: DrinkCategory.values,
                  menus: menus,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ButtonShell(
                    bone: _restaurantEditBloc.drinkButtonBone,
                    shape: ContinuousRectangleBorder(),
                    child: Text("Registrazione Completata"),
                  ),
                ),
              ],
            );
          },
          stream: _restaurantEditBloc.drinkMenusBone.outMenus,
        ),
      ),
    );
  }
}

class MenuEditView<C> extends StatelessWidget {
  final _editBloc = RestaurantEditBloc.of();
  final List<C> categories;
  final List<MenuModel<C>> menus;

  MenuEditView({Key key, @required this.categories, @required this.menus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: categories.map((category) {
          final menu = menus?.firstWhere((menu) => menu.category == category, orElse: () => null);

          final itemCount = (menu?.products?.length ?? 0);

          return SliverMenu(
            title: Text(category is FoodCategory
                ? SS.foodCategoryToMenuTitle(category)
                : translateDrinkCategory(category as DrinkCategory)),
            childCount: itemCount + 1,
            builder: (_, index) {
              if (index >= itemCount)
                return InkWell(
                  onTap: () => category is FoodCategory
                      ? _editBloc.newFood(category)
                      : _editBloc.newDrink(category as DrinkCategory),
                  child: NewProductVoidOwner(),
                );

              final product = menu.products[index];

              return InkWell(
                onTap: () => category is FoodCategory
                    ? _editBloc.inEditFood(product)
                    : _editBloc.inEditDrink(product),
                child: ProductView(
                  model: product,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
