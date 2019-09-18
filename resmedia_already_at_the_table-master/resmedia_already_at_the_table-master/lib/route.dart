import 'dart:collection';

import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/HomeOwner.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/LoginScreenOwner.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/ProductScreenOwner.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/RegisterOwnerScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/BookingScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/CartScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/CreateTableScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/HomeScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/MenuScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/ProductScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/RestaurantsScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/SigUpMoreScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/SignUpScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/SingInScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/TableScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/UserScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/check_order.dart';
import 'package:resmedia_already_at_the_table/interface/screen/favorite_screen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/paymentScreen.dart';

void route() {
  PocketRouter.init(
      routes: HashMap.from(<String, WidgetBuilder>{
    SignInScreen.ROUTE: (_) => SignInScreen(),
    SignUpScreen.ROUTE: (_) => SignUpScreen(),
    SignUpMoreScreen.ROUTE: (_) => SignUpMoreScreen(),
    HomeScreen.ROUTE: (_) => HomeScreen(),
    UserScreen.ROUTE: (_) => UserScreen(),
    BookingScreen.ROUTE: (_) => BookingScreen(),
    FavoriteScreen.ROUTE: (_) => FavoriteScreen(),
    RestaurantsScreen.ROUTE: (_) => RestaurantsScreen(),
    RestaurantScreen.ROUTE: (_) => RestaurantScreen(),
    FoodScreen.ROUTE: (_) => FoodScreen(),
    CreateTableScreen.ROUTE: (_) => CreateTableScreen(),
    TableScreen.ROUTE: (_) => TableScreen(),
    MenuScreen.ROUTE: (_) => MenuScreen(),
    CartScreen.ROUTE: (_) => CartScreen(),
    CheckOrderScreen.ROUTE: (_) => CheckOrderScreen(),
    PaymentScreen.ROUTE: (_) => PaymentScreen(),
    OwnerLoginScreen.ROUTE: (_) => OwnerLoginScreen(),
    RegisterOwnerScreen.ROUTE: (_) => RegisterOwnerScreen(),
    FoodScreenOwner.ROUTE: (_) => FoodScreenOwner(),
    DrinkScreenOwner.ROUTE: (_) => DrinkScreenOwner(),
    HomeOwnerScreen.ROUTE: (_) => HomeOwnerScreen(),
  }));
}
