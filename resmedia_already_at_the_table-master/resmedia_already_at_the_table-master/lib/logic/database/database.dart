
/*import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_already_at_the_table/data/collections.dart' as cl;
import 'package:resmedia_already_at_the_table/logic/Collections.dart';
import 'package:resmedia_already_at_the_table/logic/database/RestaurantDb.dart';
import 'package:resmedia_already_at_the_table/logic/database/TableDb.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'package:resmedia_already_at_the_table/model/products/DrinkModel.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';
import 'package:cloud_functions/cloud_functions.dart';


class Database extends FirebaseDatabase with MixinFirestoreStripeProvider, StripeProviderRule, RestaurantDb, TableDb {
  static Database _db;
  
  Database.internal({
    @required Firestore fs,
  }) : super.internal(UsersCollectionRule(), fs: fs, );

  factory Database() {
    if (_db == null) {
      final fs = Firestore.instance;

      _db = Database.internal(
        fs: fs,
      );
    }
    return _db;
  }

  final FirebaseStorage fbs = FirebaseStorage.instance;
  final CloudFunctions cf = CloudFunctions();

  final RestaurantsCollection restaurants = const RestaurantsCollection();
  final TablesCollection tables = const TablesCollection();
  final StripeCollection stripe = StripeCollection();



  Future<void> createUser({@required String uid, @required UserModel model}) async {
    await fs.collection(cl.USERS).document(uid).setData(
        model.toJson()..[users.fcmToken] = await fbMs.getToken());
  }

  Stream<UserModel> getUser(FirebaseUser user) {
    return fs.collection(cl.USERS).document(user.uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  Future<String> uploadImage(String path, File imageFile) async {
    StorageReference ref = fbs.ref().child(path).child(imageFile.path.split('/').last);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<RestaurantModel> get(String id) async {
    final res = await fs.document(id).get();
    return RestaurantModel.fromJson(res.data);
  }


  Stream<List<TableModel>> getRestaurantTables(String user, String idRestaurant) {
    return tables.col(fs)
        .where(tables.users+'.'+user, isEqualTo: true)
        .where(tables.idRestaurant, isEqualTo: idRestaurant)
        .snapshots().map((querySnap) => fromQuerySnaps(querySnap, TableModel.fromFirebase));
  }

  Stream<List<FoodModel>> getFoodsInChair(String restaurantId, Iterable<String> idProducts) {
    return getDocumentsByCollection(
      fs.collection(restaurants.id).document(restaurantId).collection(restaurants.$foods.id),
      idProducts,
      FoodModel.fromFirebase,
    );
  }
  Stream<List<DrinkModel>> getDrinksInChair(String restaurantId, Iterable<String> idProducts) {
    return getDocumentsByCollection(
      fs.collection(restaurants.id).document(restaurantId).collection(restaurants.$drinks.id),
      idProducts,
      DrinkModel.fromFirebase,
    );
  }

  Future<void> updateFoodInChair(String tableId, String chairId, String productID, valuesOrDelete) async {
    return await $chair(tableId, chairId).updateData({
      '${chairs.products}.foods.$productID': valuesOrDelete,
    });
  }

  Future<void> updateDrinkInChair(String tableId, String chairId, String productID, valuesOrDelete) async {
    return await $chair(tableId, chairId).updateData({
      '${chairs.products}.drinks.$productID': valuesOrDelete,
    });
  }
}


enum InviterError {
  INVALID_REQUEST, NOT_EXIST_USER, NOT_EXIST_TABLE, NO_FREE_CHAIR,
}



Future<int> inviteToTable(String idTable, {String email, int phoneNumber}) async {
    assert(email != null || phoneNumber != null);
    final prams = <String, dynamic>{
      'idTable': idTable,
      if (email!=null)
        'email': email,
      if (phoneNumber != null)
        'phoneNumber': phoneNumber
    };

    try {
      final res = await cf.getHttpsCallable(functionName: "invitationToTable").call(prams);
      debugPrint(res.toString());
      switch (res.data['error']) {
        case 'INVALID_REQUEST': return -1;
        case 'NOT_EXIST_USER': return 0;
        case 'NOT_EXIST_TABLE': return -2;
        case 'NO_FREE_CHAIR': return -3;
        default:
          return res.data['successCount'];
      }
    } on CloudFunctionsException catch(exc) {
      print('${exc.code} \n::: ${exc.message}\n:::${exc.details}');
      return -1;
    }
  }

  Future<void> responseInvite(ChairModel chair, bool isAccept) async {
    await cf.getHttpsCallable(functionName: 'callResponseInvitationToTable').call({
      'pathChair': chair.path,
      'isAccept': isAccept,
    });
    print("responseInvite(chair: $chair, isAccept: $isAccept");
  }
*/


