// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FoodModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodModel _$FoodModelFromJson(Map json) {
  return FoodModel(
    reference: FirebaseModelRule.documentReferenceFromJson(json['reference']),
    img: json['img'] as String,
    title: json['title'] == null
        ? null
        : Translations.fromJson((json['title'] as Map)?.map(
            (k, e) => MapEntry(k as String, e as String),
          )),
    description: json['description'] == null
        ? null
        : Translations.fromJson((json['description'] as Map)?.map(
            (k, e) => MapEntry(k as String, e as String),
          )),
    price: RationalJsonKey.rationalFromJson(json['price']),
    recipe: json['recipe'] == null
        ? null
        : Translations.fromJson((json['recipe'] as Map)?.map(
            (k, e) => MapEntry(k as String, e as String),
          )),
    sommelier: json['sommelier'] == null
        ? null
        : Translations.fromJson((json['sommelier'] as Map)?.map(
            (k, e) => MapEntry(k as String, e as String),
          )),
    category: _$enumDecodeNullable(_$FoodCategoryEnumMap, json['category']),
  );
}

Map<String, dynamic> _$FoodModelToJson(FoodModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('reference',
      FirebaseModelRule.documentReferenceToJson(instance.reference));
  writeNotNull('title', instance.title?.toJson());
  writeNotNull('description', instance.description?.toJson());
  writeNotNull('price', RationalJsonKey.rationalToJson(instance.price));
  writeNotNull('recipe', instance.recipe?.toJson());
  writeNotNull('sommelier', instance.sommelier?.toJson());
  writeNotNull('img', instance.img);
  writeNotNull('category', _$FoodCategoryEnumMap[instance.category]);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$FoodCategoryEnumMap = {
  FoodCategory.appetizer: 'appetizer',
  FoodCategory.firstCourses: 'firstCourses',
  FoodCategory.mainCourses: 'mainCourses',
  FoodCategory.seafoodMenu: 'seafoodMenu',
  FoodCategory.meatMenu: 'meatMenu',
  FoodCategory.sideDish: 'sideDish',
  FoodCategory.desert: 'desert',
};
