import 'package:flutter/widgets.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';


class TypeOfCuisineView extends Text {
  //final _bloc = RepositoryBloc.of();

  TypeOfCuisineView(TypeOfCuisine typeOfCuisine) : super(() {
    switch (typeOfCuisine) {
      case TypeOfCuisine.creative: return "Creativa";
      case TypeOfCuisine.traditional: return "Tradizionale";
      case TypeOfCuisine.mediterranean: return "Mediterranea";
      case TypeOfCuisine.allYouCanEat: return "All you can eat";
      case TypeOfCuisine.vegan: return "Vegana";
      case TypeOfCuisine.vegetarian: return "Vegetariana";
      case TypeOfCuisine.chinese: return "Cinese";
      case TypeOfCuisine.international: return "Internazionale";
      case TypeOfCuisine.italian: return "Italiana";
      case TypeOfCuisine.tuscan: return "Toscana";
      case TypeOfCuisine.japanese: return "Jiapponese";
      case TypeOfCuisine.pizza: return "Pizza";
      case TypeOfCuisine.fish: return "Pesce";
      case TypeOfCuisine.meat: return "Carne";
      default: return "Ristoranti";
    }
  }());
}