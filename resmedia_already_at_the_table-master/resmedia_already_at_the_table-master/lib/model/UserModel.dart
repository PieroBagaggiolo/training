import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoder/geocoder.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class UserModel extends UserModelFsBase {
  final SocialClass socialClass;
  final String nominative;
  final String email;
  final int phoneNumber;
  final List<String> yourRestaurants;
  @JsonKey(toJson: addressToJson, fromJson: addressFromJson)
  final Address address;

  UserModel({
    DocumentReference reference,
    FirebaseUser firebaseUser,
    String fcmToken,
    this.socialClass,
    this.nominative,
    this.email,
    this.phoneNumber,
    this.address,
    this.yourRestaurants,
  }) : super(
          reference,
          firebaseUser,
          fcmToken: fcmToken,
        );

  int get registrationLv => nominative == null || address == null || phoneNumber == null ? 0 : 1;

  static UserModel fromJson(Map json) => _$UserModelFromJson(json);
  static UserModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static Address addressFromJson(Map json) => json == null ? null : Address.fromMap(json);
  static Map addressToJson(Address address) => address?.toMap();
}

enum SocialClass {
  user,
  restaurateur,
}

/*class User extends UserBase<UserModel> {
  User(FirebaseUser userFb, UserModel model) : super(userFb, model);
}*/
