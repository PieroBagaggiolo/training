import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rational/rational.dart';


abstract class ProductModel extends FirebaseModel implements ProductCartPriceRule {
  final Translations title, description;
  String get img;
  @JsonKey(fromJson: RationalJsonKey.rationalFromJson, toJson: RationalJsonKey.rationalToJson)
  final Rational price;

  ProductModel({DocumentReference reference,
    @required this.title, @required this.description,
    @required this.price,
  }) : super(reference);
}






