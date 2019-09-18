
/*import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/RegisterOwnerScreen.dart';
import 'package:resmedia_already_at_the_table/backend/logic/RestaurantBloc.dart';
import 'package:resmedia_already_at_the_table/interface/page/menu_page.dart';
import 'package:resmedia_already_at_the_table/interface/view/ProductView.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';


const double _kMinButtonSize = 48.0;

class IconNavigator extends StatelessWidget {
  final double iconSize;
  final EdgeInsets padding;
  final VoidCallback onTap;
  final Widget icon, text;

  const IconNavigator({Key key,
    this.iconSize = 24.0,
    this.padding = const EdgeInsets.all(8.0),
    this.onTap,
    @required this.icon,
    @required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: _kMinButtonSize, minHeight: _kMinButtonSize),
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: iconSize,
                width: iconSize,
                child: IconTheme.merge(
                  data: IconThemeData(
                    size: iconSize,
                  ),
                  child: icon,
                ),
              ),
              text,
            ],
          ),
        ),
      ),
    );
  }
}*/






