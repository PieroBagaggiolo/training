import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/data/icons/res_media_icons.dart';

class DishDay extends StatelessWidget {
  final Widget day, title, titleDish, price, bottom;
  final ImageProvider background, dish;

  const DishDay(
      {Key key,
      @required this.title,
      @required this.day,
      @required this.titleDish,
      @required this.price,
      @required this.bottom,
      @required this.background,
      @required this.dish})
      : super(key: key);

  Widget text(Widget child) => Container(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white, //                   <--- border color
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          color: Colors.black87,
        ),
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: background,
          fit: BoxFit.fill,
        ),
      ),
      child: LayoutBuilder(
        builder: (_, box) {
          final size = min(box.maxHeight, box.maxWidth);
          final iconSize = size / 8, padding = size / 32, dishSize = size / 1.7;

          return Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    SizedBox(
                      width: size / 1.5,
                      child: title,
                    ),
                    FractionalTranslation(translation: Offset(0.0, 0.5), child: day),
                  ],
                ),
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(dishSize),
                      child: SizedBox(
                        width: dishSize,
                        height: dishSize,
                        child: Image(
                          image: dish,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      child: FractionalTranslation(
                        translation: Offset(0.0, -0.5),
                        child: text(titleDish),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: FractionalTranslation(
                        translation: Offset(0.0, 0.5),
                        child: text(price),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      ResMedia.promo,
                      size: iconSize,
                      color: Colors.white70,
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 2,
                            width: box.maxWidth - (iconSize + padding * 2),
                            color: theme.primaryColor,
                          ),
                          SizedBox(
                            height: size / 32,
                          ),
                          LayoutBuilder(
                            builder: (_, box) {
                              return SizedBox(
                                width: box.maxWidth,
                                child: bottom,
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
