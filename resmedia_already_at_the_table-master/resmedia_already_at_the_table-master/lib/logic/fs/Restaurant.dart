import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';

final _fs = Firestore.instance;

mixin RestaurantDispenser implements Dispenser<RestaurantModel> {
  String get _title => 'title';
  String get _typesOfCuisine => 'typesOfCuisine';
  String get _priceRating => 'priceRating';
  String get _owner => "owner";
  String get _geoPointFlutter => "geoPointFlutter";

  @override
  FromJson<RestaurantModel> get fromJson => RestaurantModel.fromJson;
}

class RestaurantCl extends CollectionFs<RestaurantModel> with RestaurantDispenser {
  static const String _id = 'restaurants';

  RestaurantCl() : super(_fs.collection(_id));

  RestaurantDc document([String id]) => RestaurantDc(reference.document(id));

  Query _searchByFilters({RestaurantFilters filters: const RestaurantFilters()}) {
    var query = reference.limit(10); //orderBy("title.it");
    if (filters.typeOfCuisine != null)
      query = query.where(
        _typesOfCuisine,
        arrayContains: filters.typeOfCuisine.toString().split('.').last,
      );
    if (filters.priceRating != null)
      query = query.where(_priceRating, isEqualTo: filters.priceRating);
    return query;
  }

  Stream<List<RestaurantModel>> outerSearchByPosition({
    @required GeoFirePoint point,
    RestaurantFilters filters: const RestaurantFilters(),
  }) {
    return GeoFireCollectionRef(_searchByFilters(filters: filters))
        .within(
      center: point,
      radius: filters.radiusSearch,
      field: _geoPointFlutter,
    )
        .map((documents) {
      return documents.map((document) => byDocument(document)).toList();
    });
  }

  Stream<List<RestaurantModel>> outerSearchByText({
    @required String text,
    RestaurantFilters filters: const RestaurantFilters(),
  }) {
    var query = _searchByFilters(filters: filters);
    if (text != null && text.isNotEmpty) {
      final endText = text.substring(0, text.length - 1) +
          String.fromCharCode(text.codeUnitAt(text.length - 1) + 1);
      query = query.orderBy('$_title.it').startAt([text]).endAt([endText]);
    }
    return byQuery(query);
  }

  Stream<RestaurantModel> outerYourRestaurant({@required String userID}) {
    return byQuery(reference.limit(1).where(_owner, isEqualTo: userID)).map((restaurants) {
      return restaurants == null || restaurants.length == 0 ? null : restaurants.first;
    });
  }

  Stream<List<RestaurantModel>> outBasilAndMondial() {
    return getDocumentsByCollection(this, ["2lOWCscQfTWqmaJGTenh", "kG5kMdEpRsXfjqSlHkhZ"]);
  }
}

class RestaurantFilters {
  final int priceRating;
  final TypeOfCuisine typeOfCuisine;
  final double radiusSearch;

  const RestaurantFilters({this.priceRating, this.typeOfCuisine, this.radiusSearch: 1250});
}

class RestaurantDc extends DocumentFs<RestaurantModel> with RestaurantDispenser {
  RestaurantDc(DocumentReference reference) : super(reference);

  FoodCl foods() => FoodCl(reference);

  DrinkCl drinks() => DrinkCl(reference);

  TableCl tables() => TableCl(reference);
}

mixin FoodDispenser implements Dispenser<FoodModel> {
  @override
  FromJson<FoodModel> get fromJson => FoodModel.fromJson;
}

class FoodCl extends CollectionFs<FoodModel> with FoodDispenser {
  FoodCl(DocumentReference reference) : super(reference.collection('foods'));

  FoodDc document([String id]) => FoodDc(reference.document(id));
}

class FoodDc extends DocumentFs<FoodModel> with FoodDispenser {
  FoodDc(DocumentReference reference) : super(reference);
}

mixin DrinkDispenser implements Dispenser<DrinkModel> {
  @override
  FromJson<DrinkModel> get fromJson => DrinkModel.fromJson;
}

class DrinkCl extends CollectionFs<DrinkModel> with DrinkDispenser {
  static const $id = 'drinks';

  DrinkCl(DocumentReference reference) : super(reference.collection($id));

  DrinkDc document([String id]) => DrinkDc(reference.document(id));
}

class DrinkDc extends DocumentFs<DrinkModel> with DrinkDispenser {
  DrinkDc(DocumentReference reference) : super(reference);
}

mixin TableDispenser implements Dispenser<TableModel> {
  String get _dateTime => "dateTime";
  String get _users => "users";
  //String get _idRestaurant => "idRestaurant";

  @override
  FromJson<TableModel> get fromJson => TableModel.fromJson;
}

mixin _Outer on TableDispenser {
  Query get query;
  Stream<List<TableModel>> userOuter({@required String userID}) {
    final query = this.query.where(_users, arrayContains: userID);

    return byQuery(query.orderBy(_dateTime, descending: true));
  }
}

class TableQr extends QueryFs<TableModel> with TableDispenser, _Outer {
  TableQr() : super(_fs.collectionGroup(TableCl._id));
}

class TableCl extends CollectionFs<TableModel> with TableDispenser, _Outer {
  static const String _id = 'tables';

  TableCl(DocumentReference reference) : super(reference.collection(_id));

  TableDc document(String id) => TableDc(reference.document(id));
}

class TableDc extends DocumentFs<TableModel> with TableDispenser {
  TableDc(DocumentReference reference) : super(reference);

  ChairCl chairs() => ChairCl(reference);
}

mixin ChairDispenser implements Dispenser<ChairModel> {
  //String get _user => 'user';
  String get _products => 'products';
  String get _foods => 'foods';
  String get _drinks => 'drinks';

  @override
  FromJson<ChairModel> get fromJson => ChairModel.fromJson;
}

class ChairCl extends CollectionFs<ChairModel> with ChairDispenser {
  static const String _id = 'chairs';

  ChairCl(DocumentReference reference) : super(reference.collection(_id));

  TableDc document(String id) => TableDc(reference.document(id));

  Stream<List<ChairModel>> nominativeOuter() {
    return byQuery(reference).map((chairs) {
      return chairs
        ..sort((bef, aft) {
          return bef.user == null ? 1 : aft.user == null ? 0 : bef.user.compareTo(aft.user);
        });
    });
  }
}

class ChairDc extends DocumentFs<ChairModel> with ChairDispenser {
  ChairDc(DocumentReference reference) : super(reference);

  Future<void> updateFood(String productID, valuesOrDelete) async {
    return await reference.updateData({
      '$_products.$_foods.$productID': valuesOrDelete,
    });
  }

  Future<void> updateDrink(String productID, valuesOrDelete) async {
    return await reference.updateData({
      '$_products.$_drinks.$productID': valuesOrDelete,
    });
  }
}
