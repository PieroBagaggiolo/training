import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/screen/HomeScreen.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/simulation.dart';

import 'RegisterOwnerScreen.dart';

Widget _inputField(String title, Widget field, ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: theme.textTheme.caption,
          ),
        ),
        field
      ],
    ),
  );
}

class OwnerLoginScreen extends StatelessWidget {
  static const ROUTE = "OwnerLoginScreen";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Area riservata: Login"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(SPACE * 2),
        children: <Widget>[
          SizedBox(
            height: SPACE,
          ),
          Text(
            "Area Riservata",
            style: theme.textTheme.display1,
            textAlign: TextAlign.center,
          ),
          Text(
            "Proprietario",
            style: theme.textTheme.display1,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: SPACE,
          ),
          _inputField(
              "Email",
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              theme),
          SizedBox(
            height: SPACE,
          ),
          _inputField(
              "Password",
              TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
              theme),
          SizedBox(
            height: SPACE * 2,
          ),
          RaisedButton(
            onPressed: () {
              Sm.configure(isSimulation: false);
              PocketRouter()
                ..popUntil(context, HomeScreen.ROUTE)
                ..push(context, RegisterOwnerScreen.ROUTE);

              /// NOT IMPLEMENTED
              //Navigator.pushNamed(context, RestaurantScreen.ROUTE, arguments: restaurantModels[0]);
            },
            color: theme.primaryColor,
            child: Text("Registrati"),
          ),
        ],
      ),
    );
  }
}
