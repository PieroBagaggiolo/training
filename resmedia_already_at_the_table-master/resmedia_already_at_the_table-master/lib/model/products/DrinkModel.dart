import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:rational/rational.dart';
import 'package:resmedia_already_at_the_table/model/products/ProductModel.dart';


part 'DrinkModel.g.dart';


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class DrinkModel extends ProductModel {
  final DrinkCategory category;
  final List<String> imgs;

  String get img => imgs.first;

  DrinkModel({DocumentReference reference, this.category, this.imgs,
    Translations title, Translations description, Rational price,
  }) : super(
    reference: reference,
    title: title, description: description,
    price: price,
  );

  static DrinkModel fromJson(Map json) => _$DrinkModelFromJson(json);
  static DrinkModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);
  Map<String, dynamic> toJson() => _$DrinkModelToJson(this);

  @required
  String toString() => toJson().toString();
}


enum DrinkCategory {
  drink, wine, alcoholic, coffee
}

String translateDrinkCategory(DrinkCategory category) {
  switch (category) {
    case DrinkCategory.drink:
      return "Bevande";
    case DrinkCategory.wine:
      return "Vini";
    case DrinkCategory.alcoholic:
      return "Alcolici";
    case DrinkCategory.coffee:
      return "Caffetteria";
    default: return "";
  }
}