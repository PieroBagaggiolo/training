

import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';

import 'i18n.dart';

class SS {

  S get s => S.current;

  static String foodCategoryToMenuTitle(FoodCategory category) {
    switch (category) {
      case FoodCategory.appetizer:
        return "Antipasti";
      case FoodCategory.firstCourses:
        return "Primi Piatti";
      case FoodCategory.mainCourses:
        return "Secondi Piatti";
      case FoodCategory.seafoodMenu:
        return "Menu di Mare";
      case FoodCategory.meatMenu:
        return "Menu di Terra";
      case FoodCategory.sideDish:
        return "Contorni";
      case FoodCategory.desert:
        return "Desert";
      default: return "";
    }
  }

}