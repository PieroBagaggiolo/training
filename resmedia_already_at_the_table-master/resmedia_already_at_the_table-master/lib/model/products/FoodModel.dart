import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:rational/rational.dart';
import 'package:resmedia_already_at_the_table/model/products/ProductModel.dart';


part 'FoodModel.g.dart';


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class FoodModel extends ProductModel {
  final Translations recipe, sommelier;
  final String img;
  final FoodCategory category;

  FoodModel({DocumentReference reference,
    this.img, Translations title, Translations description, Rational price,
    this.recipe, this.sommelier, this.category,
  }) :
        super(
        reference: reference,
        title: title, description: description,
        price: price,
      );

  static FoodModel fromJson(Map json) => _$FoodModelFromJson(json);
  static FoodModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);
  Map<String, dynamic> toJson() => _$FoodModelToJson(this);
  @required
  String toString() => toJson().toString();

  factory FoodModel.product(ProductModel product) {
    return product == null ? null : FoodModel(
      reference: product.reference,
      price: product.price,
      title: product.title,
      description: product.description,
      img: product.img,
    );
  }
}


enum FoodCategory {
  appetizer, firstCourses, mainCourses, seafoodMenu, meatMenu, sideDish, desert,
}

@deprecated
String foodCategoryToString(FoodCategory category) {
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