// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map json) {
  return UserModel(
    reference: FirebaseModelRule.documentReferenceFromJson(json['reference']),
    firebaseUser: UserModelFsBase.firebaseUserFromJson(json['firebaseUser']),
    fcmToken: json['fcmToken'] as String,
    socialClass:
        _$enumDecodeNullable(_$SocialClassEnumMap, json['socialClass']),
    nominative: json['nominative'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as int,
    address: UserModel.addressFromJson(json['address'] as Map),
    yourRestaurants:
        (json['yourRestaurants'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('reference',
      FirebaseModelRule.documentReferenceToJson(instance.reference));
  writeNotNull('firebaseUser',
      UserModelFsBase.firebaseUserToJson(instance.firebaseUser));
  writeNotNull('fcmToken', instance.fcmToken);
  writeNotNull('socialClass', _$SocialClassEnumMap[instance.socialClass]);
  writeNotNull('nominative', instance.nominative);
  writeNotNull('email', instance.email);
  writeNotNull('phoneNumber', instance.phoneNumber);
  writeNotNull('yourRestaurants', instance.yourRestaurants);
  writeNotNull('address', UserModel.addressToJson(instance.address));
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

const _$SocialClassEnumMap = {
  SocialClass.user: 'user',
  SocialClass.restaurateur: 'restaurateur',
};
