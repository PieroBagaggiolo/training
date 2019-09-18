// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DrinkModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrinkModel _$DrinkModelFromJson(Map json) {
  return DrinkModel(
    reference: FirebaseModelRule.documentReferenceFromJson(json['reference']),
    category: _$enumDecodeNullable(_$DrinkCategoryEnumMap, json['category']),
    imgs: (json['imgs'] as List)?.map((e) => e as String)?.toList(),
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
  );
}

Map<String, dynamic> _$DrinkModelToJson(DrinkModel instance) {
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
  writeNotNull('category', _$DrinkCategoryEnumMap[instance.category]);
  writeNotNull('imgs', instance.imgs);
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

const _$DrinkCategoryEnumMap = {
  DrinkCategory.drink: 'drink',
  DrinkCategory.wine: 'wine',
  DrinkCategory.alcoholic: 'alcoholic',
  DrinkCategory.coffee: 'coffee',
};
