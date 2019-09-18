import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/screen/RestaurantsScreen.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';

class TypesRestaurantListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final assetFolder = AssetHandler().getFolder("assets/imgs/restaurant/type_of_cuisine/");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: TypeOfCuisine.values.where((typeOfCuisine) {
        return assetFolder.getFileByTitle(typeOfCuisine.toString().split(".").last) != null;
      }).map((typeOfCuisine) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: SPACE),
          child: InkWell(
            onTap: () {
              RestaurantsBloc.init(RestaurantsBloc(
                repository: RepositoryBloc.of(),
                filters: RestaurantFilters(typeOfCuisine: typeOfCuisine),
              ));
              PocketRouter().push(context, RestaurantsScreen.ROUTE);
            },
            child: AspectRatio(
              aspectRatio: 3,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Image.asset(
                    assetFolder.getFileByTitle(typeOfCuisine.toString().split(".").last).path,
                    fit: BoxFit.fill,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black12],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(SPACE),
                    child: Text(
                      '${RestaurantModel.typeOfCuisineToTranslations[typeOfCuisine]}',
                      style: theme.textTheme.headline.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
