import 'package:flutter/material.dart';


class MainAppBar extends AppBar {
  MainAppBar({
    Widget title, List<Widget> actions,
  }) : super(
    centerTitle: true,
    title: title,
    actions: actions,
  );
}