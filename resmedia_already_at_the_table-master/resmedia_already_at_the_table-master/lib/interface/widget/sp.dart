import 'dart:ui';

import 'package:flutter/material.dart';


class WidthHeightApp extends StatefulWidget {
  WidthHeightApp({ Key key }) : super(key: key);

  @override
  WidthHeightAppState createState() => new WidthHeightAppState();
}

class WidthHeightAppState extends State
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    width = window.physicalSize.width;
    height = window.physicalSize.height;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  double width = 0.0;
  double height = 0.0;

  @override
  void didChangeMetrics() {
    setState(() {
      width = window.physicalSize.width;
      height = window.physicalSize.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: Builder(builder: (_context) {
          final mediaQuery = MediaQuery.of(_context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Width: $width, Height: $height'),
              Text('Width: ${mediaQuery.size.width}, Height: ${mediaQuery.size.height}'),
              Text('PixelRatio: ${mediaQuery.devicePixelRatio}'),
            ],
          );
        }),
      ),
    );
  }
}