// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types_restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypeRestaurantModel _$TypeRestaurantModelFromJson(Map json) {
  return TypeRestaurantModel(
    reference: FirebaseModelRule.documentReferenceFromJson(json['reference']),
    pos: json['pos'] as int,
    img: json['img'] as String,
    title: json['title'] == null
        ? null
        : TranslationsMap.fromJson((json['title'] as Map)?.map(
            (k, e) => MapEntry(k as String, e as String),
          )),
  );
}

Map<String, dynamic> _$TypeRestaurantModelToJson(TypeRestaurantModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('reference',
      FirebaseModelRule.documentReferenceToJson(instance.reference));
  val['img'] = instance.img;
  val['title'] = instance.title?.toJson();
  val['pos'] = instance.pos;
  return val;
}
