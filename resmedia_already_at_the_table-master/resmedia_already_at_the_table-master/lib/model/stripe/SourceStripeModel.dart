import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:json_annotation/json_annotation.dart';

part 'SourceStripeModel.g.dart';

@JsonSerializable(anyMap: true)
class SourceStripeModel extends FirebaseModel implements StripeSourceModel {
  @override
  final String token;
  @override
  final DateTime lastUse;
  @override
  final StripeCardModel card;

  SourceStripeModel({
    DocumentReference reference,
    this.token,
    this.lastUse,
    this.card,
  }) : super(reference);

  static SourceStripeModel fromJson(Map json) => _$SourceStripeModelFromJson(json);
  Map<String, dynamic> toJson() => _$SourceStripeModelToJson(this);
}
