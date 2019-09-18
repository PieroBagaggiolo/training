import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'main.dart';

String query = "https://firestore.googleapis.com/v1/projects/gia-a-tavola/databases/(default)/documents/restaurant/Tar66sfyDbdARvU4DSA9";

var user;


void testDatabase() async {
  Firestore firestore = Firestore.instance;
  await firestore.collection("restaurant").getDocuments().then((restaurantDocs) async {
    await Future.forEach<DocumentSnapshot>(restaurantDocs.documents, (restaurant) async {
      print("restaurant: "+restaurant.documentID);
      final ref = firestore.collection("restaurants").document(restaurant.documentID);
      await ref.setData(restaurant.data);
      await restaurant.reference.collection("foods").getDocuments().then((docs) async {
        final foodsRef = ref.collection("foods");
        await Future.forEach<DocumentSnapshot>(docs.documents, (doc) async {
          print("food: "+doc.documentID);
          await foodsRef.document(doc.documentID).setData(doc.data);
        });
      });
      await restaurant.reference.collection("drinks").getDocuments().then((docs) async {
        final drinksRef = ref.collection("drinks");
        await Future.forEach<DocumentSnapshot>(docs.documents, (doc) async {
          print("drink: "+doc.documentID);
          await drinksRef.document(doc.documentID).setData(doc.data);
        });
      });
    });
  });

}







void main() {
  registerFromJson<PartialChairModel>(PartialChairModel, PartialChairModel.fromJson);
  runApp(TestApp());
}


class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Firestore.instance.app.options.then(print);
    return MaterialApp(
      theme: ThemeData(
        primaryColor: PRIMARY,
        accentColor: PRIMARY_VARIANT,
        errorColor: SECONDARY,
        buttonColor: SECONDARY_VARIANT,
        colorScheme: ColorScheme.light(
          primary: PRIMARY,
          primaryVariant: PRIMARY_VARIANT,
          secondary: SECONDARY,
          secondaryVariant: SECONDARY_VARIANT,
        ),
        tabBarTheme: TabBarTheme(
          labelColor: PRIMARY,
          unselectedLabelColor: PRIMARY_VARIANT,
        ),
        indicatorColor: PRIMARY,
        iconTheme: IconThemeData(
          color: PRIMARY_VARIANT,
        ),
        textTheme: TextTheme(
          subtitle: TextStyle(color: PRIMARY, fontSize: 16),
          button: TextStyle(color: Colors.white),
          overline: TextStyle(
            color: SECONDARY, decoration: TextDecoration.underline,
            fontSize: 12.0, letterSpacing: 0.5,
          ),
          caption: TextStyle(fontSize: 13, color: PRIMARY_VARIANT),
        ),
      ),
      color: Colors.white,
      home: TestScreen(),
    );
  }
}


class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: testDatabase,
                child: Text("TEST QUERY"),
              ),
              RaisedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => SubjectScreen(),
                )),
                child: Text("OPEN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


final random = Random();

class SubjectScreen extends StatefulWidget {
  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Save"),
      ),
    );
  }
}


