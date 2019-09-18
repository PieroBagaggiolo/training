import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'types_restaurant_model.g.dart';

const String IMG_PATH = 'img_path', TITLE = 'title';

@JsonSerializable(anyMap: true, explicitToJson: true)
class TypeRestaurantModel extends FirebaseModel {
  final String img;
  final TranslationsMap title;
  final int pos;

  TypeRestaurantModel({@required DocumentReference reference,
    @required this.pos, @required this.img, @required this.title}) : super(reference);

  static TypeRestaurantModel fromJson(Map json) => _$TypeRestaurantModelFromJson(json);
  static TypeRestaurantModel fromFirebase(DocumentSnapshot snap) =>
    FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$TypeRestaurantModelToJson(this);
}

