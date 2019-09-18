import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_map/pocket_map.dart';


part 'restaurant_model.g.dart';

const RULES = 'rules';

// 43.818748
// 10.261067

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class RestaurantModel extends FirebaseModel {
  final Translations title, description;
  final int priceRating, reviewsLenght;
  final double reviewAverageVote;
  final List<String> imgs;
  final List<TypeOfCuisine> typesOfCuisine;
  final InfoRestaurantModel info;
  final int countSeats;
  @JsonKey(name: '_geoloc')
  final PocketPoint algoliaPosition;
  final String owner;
  @JsonKey(toJson: geoPointFlutterToJson, fromJson: geoPointFlutterFromJson)
  final GeoFirePoint geoPointFlutter;
  @JsonKey(toJson: addressToJson, fromJson: addressFromJson)
  final Address address;

  RestaurantModel({DocumentReference reference,
    this.title, this.description,
    this.priceRating, this.reviewsLenght, this.reviewAverageVote,
    this.typesOfCuisine, this.info, this.countSeats,
    this.imgs, this.algoliaPosition, this.owner,
    this.geoPointFlutter, this.address,
  }) : super(reference);

  String get img => imgs.first;

  String get priceRatingView {
    final str = StringBuffer();
    List.generate(priceRating??2, (_) => str.write("€"));
    return str.toString();
  }

  static RestaurantModel fromJson(Map json) => _$RestaurantModelFromJson(json);
  static RestaurantModel fromFirebase(DocumentSnapshot snap) =>
    FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  static const typeOfCuisineToTranslations = <TypeOfCuisine, Translations> {
    TypeOfCuisine.creative: const TranslationsConst(
      it: "Creativa",
    ), TypeOfCuisine.traditional: const TranslationsConst(
      it: "Tradizionale",
    ), TypeOfCuisine.mediterranean: const TranslationsConst(
      it: "Mediterranea",
    ), TypeOfCuisine.allYouCanEat: const TranslationsConst(
      en: "All-You-Can-Eat",
    ), TypeOfCuisine.vegan: const TranslationsConst(
      it: "Vegana",
    ), TypeOfCuisine.vegetarian: const TranslationsConst(
      it: "Vegetariana",
    ), TypeOfCuisine.chinese: const TranslationsConst(
      it: "Chinese",
    ), TypeOfCuisine.international: const TranslationsConst(
      it: "Internazionale",
    ), TypeOfCuisine.italian: const TranslationsConst(
      it: "Italiana",
    ), TypeOfCuisine.tuscan: const TranslationsConst(
      it: "Toscana",
    ), TypeOfCuisine.japanese: const TranslationsConst(
      it: "Giapponese",
    ), TypeOfCuisine.pizza: const TranslationsConst(
      it: "Pizza",
    ), TypeOfCuisine.fish: const TranslationsConst(
      it: "Pesce",
    ), TypeOfCuisine.meat: const TranslationsConst(
      it: "Carne",
    ),
  };

  static GeoFirePoint geoPointFlutterFromJson(Map json) {
    if (json == null) return null;
    final coordinates = json['geopoint'] as GeoPoint;
    return GeoFirePoint(coordinates.latitude, coordinates.longitude);
  }
  static Map geoPointFlutterToJson(GeoFirePoint point) => point?.data;

  static Address addressFromJson(Map json) => json == null ? null : Address.fromMap(json);
  static Map addressToJson(Address address) => address?.toMap();
}
enum TypeOfCuisine {
  creative, traditional, mediterranean, allYouCanEat, vegan, vegetarian,
  chinese, international, italian, tuscan, japanese,
  pizza, fish, meat,
}


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class InfoRestaurantModel {
  final List<GeneralInfo> general;
  final List<DressCodeInfo> dressCode;
  final ParkingInfoModel parking;


  InfoRestaurantModel({
    this.general, this.dressCode, this.parking,
  });

  static InfoRestaurantModel fromJson(Map json) => _$InfoRestaurantModelFromJson(json);
  Map<String, dynamic> toJson() => _$InfoRestaurantModelToJson(this);
}
enum GeneralInfo {
  airConditioned, wifi, cocktailBar, garden,
}
enum DressCodeInfo {
  elegant, casual, sporty,
}


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class ParkingInfoModel {
  final PropertyParking property;
  final DimensionParking dimension;

  ParkingInfoModel({
    this.property, this.dimension,
  });

  static ParkingInfoModel fromJson(Map json) => _$ParkingInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$ParkingInfoModelToJson(this);
}
enum PropertyParking {
  private, public,
}
enum DimensionParking {
  small, medium, large,
}


// BF = Latitudine: 43.818707 | Longitudine: 10.261093


