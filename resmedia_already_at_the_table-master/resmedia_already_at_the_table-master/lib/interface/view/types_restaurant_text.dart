import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/view/TypeRestaurantView.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';


class TypesRestaurantText extends StatelessWidget {
  final List<TypeOfCuisine> typesOfCuisine;

  TypesRestaurantText({Key key, @required this.typesOfCuisine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: typesOfCuisine.map((category) => TypeRestaurantView(typeOfCuisine: category)).toList(),
    );
  }
}
