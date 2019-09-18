// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantModelFromJson(Map json) {
  return RestaurantModel(
    reference: FirebaseModelRule.documentReferenceFromJson(json['reference']),
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
    priceRating: json['priceRating'] as int,
    reviewsLenght: json['reviewsLenght'] as int,
    reviewAverageVote: (json['reviewAverageVote'] as num)?.toDouble(),
    typesOfCuisine: (json['typesOfCuisine'] as List)
        ?.map((e) => _$enumDecodeNullable(_$TypeOfCuisineEnumMap, e))
        ?.toList(),
    info: json['info'] == null
        ? null
        : InfoRestaurantModel.fromJson(json['info'] as Map),
    countSeats: json['countSeats'] as int,
    imgs: (json['imgs'] as List)?.map((e) => e as String)?.toList(),
    algoliaPosition: json['_geoloc'] == null
        ? null
        : PocketPoint.fromJson(json['_geoloc'] as Map),
    owner: json['owner'] as String,
    geoPointFlutter:
        RestaurantModel.geoPointFlutterFromJson(json['geoPointFlutter'] as Map),
    address: RestaurantModel.addressFromJson(json['address'] as Map),
  );
}

Map<String, dynamic> _$RestaurantModelToJson(RestaurantModel instance) {
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
  writeNotNull('priceRating', instance.priceRating);
  writeNotNull('reviewsLenght', instance.reviewsLenght);
  writeNotNull('reviewAverageVote', instance.reviewAverageVote);
  writeNotNull('imgs', instance.imgs);
  writeNotNull('typesOfCuisine',
      instance.typesOfCuisine?.map((e) => _$TypeOfCuisineEnumMap[e])?.toList());
  writeNotNull('info', instance.info?.toJson());
  writeNotNull('countSeats', instance.countSeats);
  writeNotNull('_geoloc', instance.algoliaPosition?.toJson());
  writeNotNull('owner', instance.owner);
  writeNotNull('geoPointFlutter',
      RestaurantModel.geoPointFlutterToJson(instance.geoPointFlutter));
  writeNotNull('address', RestaurantModel.addressToJson(instance.address));
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

const _$TypeOfCuisineEnumMap = {
  TypeOfCuisine.creative: 'creative',
  TypeOfCuisine.traditional: 'traditional',
  TypeOfCuisine.mediterranean: 'mediterranean',
  TypeOfCuisine.allYouCanEat: 'allYouCanEat',
  TypeOfCuisine.vegan: 'vegan',
  TypeOfCuisine.vegetarian: 'vegetarian',
  TypeOfCuisine.chinese: 'chinese',
  TypeOfCuisine.international: 'international',
  TypeOfCuisine.italian: 'italian',
  TypeOfCuisine.tuscan: 'tuscan',
  TypeOfCuisine.japanese: 'japanese',
  TypeOfCuisine.pizza: 'pizza',
  TypeOfCuisine.fish: 'fish',
  TypeOfCuisine.meat: 'meat',
};

InfoRestaurantModel _$InfoRestaurantModelFromJson(Map json) {
  return InfoRestaurantModel(
    general: (json['general'] as List)
        ?.map((e) => _$enumDecodeNullable(_$GeneralInfoEnumMap, e))
        ?.toList(),
    dressCode: (json['dressCode'] as List)
        ?.map((e) => _$enumDecodeNullable(_$DressCodeInfoEnumMap, e))
        ?.toList(),
    parking: json['parking'] == null
        ? null
        : ParkingInfoModel.fromJson(json['parking'] as Map),
  );
}

Map<String, dynamic> _$InfoRestaurantModelToJson(InfoRestaurantModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('general',
      instance.general?.map((e) => _$GeneralInfoEnumMap[e])?.toList());
  writeNotNull('dressCode',
      instance.dressCode?.map((e) => _$DressCodeInfoEnumMap[e])?.toList());
  writeNotNull('parking', instance.parking?.toJson());
  return val;
}

const _$GeneralInfoEnumMap = {
  GeneralInfo.airConditioned: 'airConditioned',
  GeneralInfo.wifi: 'wifi',
  GeneralInfo.cocktailBar: 'cocktailBar',
  GeneralInfo.garden: 'garden',
};

const _$DressCodeInfoEnumMap = {
  DressCodeInfo.elegant: 'elegant',
  DressCodeInfo.casual: 'casual',
  DressCodeInfo.sporty: 'sporty',
};

ParkingInfoModel _$ParkingInfoModelFromJson(Map json) {
  return ParkingInfoModel(
    property: _$enumDecodeNullable(_$PropertyParkingEnumMap, json['property']),
    dimension:
        _$enumDecodeNullable(_$DimensionParkingEnumMap, json['dimension']),
  );
}

Map<String, dynamic> _$ParkingInfoModelToJson(ParkingInfoModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('property', _$PropertyParkingEnumMap[instance.property]);
  writeNotNull('dimension', _$DimensionParkingEnumMap[instance.dimension]);
  return val;
}

const _$PropertyParkingEnumMap = {
  PropertyParking.private: 'private',
  PropertyParking.public: 'public',
};

const _$DimensionParkingEnumMap = {
  DimensionParking.small: 'small',
  DimensionParking.medium: 'medium',
  DimensionParking.large: 'large',
};
