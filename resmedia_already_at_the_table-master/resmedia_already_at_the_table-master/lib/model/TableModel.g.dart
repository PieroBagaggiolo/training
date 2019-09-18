// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TableModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableModel _$TableModelFromJson(Map json) {
  return TableModel(
    reference: FirebaseModelRule.documentReferenceFromJson(json['reference']),
    total: json['total'] as int,
    title: json['title'] as String,
    dateTime: json['dateTime'] == null
        ? null
        : DateTime.parse(json['dateTime'] as String),
    countChairs: json['countChairs'] as int,
    users: (json['users'] as List)?.map((e) => e as String)?.toList(),
    idRestaurant: json['idRestaurant'] as String,
    titleRestaurant: json['titleRestaurant'] == null
        ? null
        : Translations.fromJson((json['titleRestaurant'] as Map)?.map(
            (k, e) => MapEntry(k as String, e as String),
          )),
  );
}

Map<String, dynamic> _$TableModelToJson(TableModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('reference',
      FirebaseModelRule.documentReferenceToJson(instance.reference));
  writeNotNull('idRestaurant', instance.idRestaurant);
  writeNotNull('titleRestaurant', instance.titleRestaurant?.toJson());
  writeNotNull('title', instance.title);
  writeNotNull('countChairs', instance.countChairs);
  writeNotNull('dateTime', instance.dateTime?.toIso8601String());
  writeNotNull('users', instance.users);
  writeNotNull('total', instance.total);
  return val;
}

PartialChairModel _$PartialChairModelFromJson(Map json) {
  return PartialChairModel(
    id: json['id'] as String,
    nominative: json['nominative'] as String,
    state: _$enumDecodeNullable(_$MenuStatusEnumMap, json['state']),
  );
}

Map<String, dynamic> _$PartialChairModelToJson(PartialChairModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('nominative', instance.nominative);
  writeNotNull('state', _$MenuStatusEnumMap[instance.state]);
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

const _$MenuStatusEnumMap = {
  MenuStatus.OPEN: 'OPEN',
  MenuStatus.CLOSED: 'CLOSED',
  MenuStatus.ORDERED: 'ORDERED',
};

ChairModel _$ChairModelFromJson(Map json) {
  return ChairModel(
    reference: FirebaseModelRule.documentReferenceFromJson(json['reference']),
    isFree: json['isFree'] as bool,
    menuState: _$enumDecodeNullable(_$MenuStatusEnumMap, json['menuState']),
    products: json['products'] == null
        ? null
        : ProductsModel.fromJson(json['products'] as Map),
    user: json['user'] as String,
    nominative: json['nominative'] as String,
  );
}

Map<String, dynamic> _$ChairModelToJson(ChairModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('reference',
      FirebaseModelRule.documentReferenceToJson(instance.reference));
  writeNotNull('isFree', instance.isFree);
  writeNotNull('menuState', _$MenuStatusEnumMap[instance.menuState]);
  writeNotNull('user', instance.user);
  writeNotNull('nominative', instance.nominative);
  writeNotNull('products', instance.products?.toJson());
  return val;
}

ProductsModel _$ProductsModelFromJson(Map json) {
  return ProductsModel(
    foods: json['foods'] == null
        ? null
        : ArrayDocObj.fromJson((json['foods'] as Map)?.map(
            (k, e) => MapEntry(
                k as String,
                (e as Map)?.map(
                  (k, e) => MapEntry(k as String, e),
                )),
          )),
    drinks: json['drinks'] == null
        ? null
        : ArrayDocObj.fromJson((json['drinks'] as Map)?.map(
            (k, e) => MapEntry(
                k as String,
                (e as Map)?.map(
                  (k, e) => MapEntry(k as String, e),
                )),
          )),
  );
}

Map<String, dynamic> _$ProductsModelToJson(ProductsModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('foods', instance.foods?.toJson());
  writeNotNull('drinks', instance.drinks?.toJson());
  return val;
}
