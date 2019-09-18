import 'package:easy_firebase/easy_firebase.dart';
import 'package:resmedia_already_at_the_table/logic/Collections.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';


mixin RestaurantDb implements FirebaseDatabase {
  RestaurantsCollection get restaurants;

  Stream<List<RestaurantModel>> getRestaurants() {
    return fs.collection(restaurants.id).snapshots().map((query) {
      return query.documents.map((snap) => RestaurantModel.fromFirebase(snap)).toList();
    });
  }

  Stream<RestaurantModel> getAdminRestaurant(String uid) async* {
    final query = fs.collection(restaurants.id).where('$RULES.$uid', isEqualTo: "admin").limit(1).snapshots();
    await for(final snap in query) {
      yield snap.documents.map(RestaurantModel.fromFirebase).first;
    }
  }

  Stream<RestaurantModel> getRestaurant(String path) {
    return fs.collection(restaurants.id).document(path)
        .snapshots().map(RestaurantModel.fromFirebase);
  }

  Stream<List<FoodModel>> getFoods(String idRestaurant) {
    return fs.collection(restaurants.id).document(idRestaurant).collection(restaurants.$foods.id)
        .snapshots().map((querySnap) => fromQuerySnaps(querySnap, FoodModel.fromFirebase));
  }

  Stream<List<DrinkModel>> getDrinks(String idRestaurant) {
    return fs.collection(restaurants.id).document(idRestaurant).collection(restaurants.$drinks.id)
        .snapshots().map((querySnap) => fromQuerySnaps(querySnap, DrinkModel.fromFirebase));
  }

  Stream<FoodModel> getFood(String path) {
    return fs.document(path).snapshots().map(FoodModel.fromFirebase);
  }

  Future<DrinkModel> getDrink(String path) async {
    final snap = await fs.document(path).get();
    return DrinkModel.fromFirebase(snap);
  }


}