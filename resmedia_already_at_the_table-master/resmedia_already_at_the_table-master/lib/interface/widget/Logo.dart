import 'package:flutter/widgets.dart';
import 'package:resmedia_already_at_the_table/r.dart';


class Logo extends SizedBox {
  Logo() : super(
    height: 70.0,
    child: Image.asset(R.assetsImgLogo, fit: BoxFit.contain),
  );
}
