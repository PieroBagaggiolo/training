import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';


class TypeRestaurantView extends StatelessWidget {
  final TypeOfCuisine typeOfCuisine;

  const TypeRestaurantView({Key key, @required this.typeOfCuisine}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget> [
        Bullet(),
        Text('${RestaurantModel.typeOfCuisineToTranslations[typeOfCuisine].text}'),
      ]
    );
  }
}


class TypeFoodView extends StatelessWidget {
  final String model;

  const TypeFoodView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget> [
          Bullet(color: theme.errorColor,),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Text(model, style: theme.textTheme.subtitle.copyWith(color: theme.errorColor),),
          ),
        ]
    );
  }
}


class Bullet extends StatelessWidget{
  final double dim;
  final Color color;

  const Bullet({Key key, this.dim: 4, this.color: Colors.black}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      height: dim,
      width: dim,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}