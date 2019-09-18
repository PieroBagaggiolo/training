import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/data/icons/res_media_icons.dart';
import 'package:resmedia_already_at_the_table/data/tmp/menu.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/interface/widget/dish_day.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/r.dart';

class PromoPage extends StatelessWidget {
  final repositoryBloc = RepositoryBloc.of();

  final AssetFolder assetFolder = AssetHandler().getFolder('assets/imgs/restaurant/dish_of_day/');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DishDay(
      title: Image.asset(
        assetFolder.getFileByLocale(repositoryBloc.locale).path,
        fit: BoxFit.fitWidth,
      ),
      day: Text(
        "Venerdì",
        style: theme.textTheme.title.copyWith(
          fontFamily: 'Pacifico',
          fontSize: 22,
        ),
      ),
      titleDish:
          Text('${foodModel.title}', style: theme.textTheme.body2.copyWith(color: Colors.white)),
      price: Text(
        "€ ${foodModel.price}",
        style: theme.textTheme.body2.copyWith(color: Colors.white),
      ),
      bottom: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "*valore piatto €18",
              textAlign: TextAlign.center,
              style: theme.textTheme.body2.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              "SCONTO: 30%",
              textAlign: TextAlign.center,
              style: theme.textTheme.title.copyWith(fontSize: 14),
            ),
          )
        ],
      ),
      background: AssetImage(R.assetsImgPromoBackground),
      dish: AssetImage(foodModel.img),
    );
  }
}

class PromoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: <Widget>[
          Image.asset(R.assetsImgPromoBackground),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  height: 64 + SPACE * 2,
                  width: 64 + SPACE * 2,
                  child: Stack(
                    children: <Widget>[
                      ClipPath(
                        child: Container(
                          color: Colors.transparent,
                        ),
                        clipper: TriangleClipper(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(SPACE),
                        child: Icon(
                          ResMedia.promo,
                          size: 64.0,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: SPACE * 2,
              ),
              Padding(
                padding: const EdgeInsets.all(SPACE),
                child: Container(
                  padding: const EdgeInsets.all(SPACE),
                  color: Colors.white70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Piatto del giorno",
                        style: theme.textTheme.title,
                      ),
                      RaisedButton(
                        onPressed: () => {}, //openScreen(context, FoodScreen(path: foodModel,)),
                        color: theme.primaryColor,
                        child: Text("Scopri"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.width);
    path.lineTo(size.height, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
