import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:resmedia_already_at_the_table/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';

class RestaurantCellView extends StatelessWidget {
  final UserBloc _userBloc = UserBloc.of();
  final RestaurantModel model;

  RestaurantCellView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return IconTheme(
      data: theme.iconTheme.copyWith(
        size: theme.textTheme.caption.fontSize * 1.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: CachedNetworkImage(
              imageUrl: model.img,
              placeholder: (_, __) => const Center(
                child: const CircularProgressIndicator(),
              ),
              fit: BoxFit.cover,
              cacheManager: CacheManager.monthTwo(),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ReviewView(model: model),
              ObservableBuilder<GeoFirePoint>(
                stream: _userBloc.outPoint,
                builder: (_, location, state) {
                  if (location == null) return const SizedBox();

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.directions_car),
                      const SizedBox(width: 4.0),
                      Text(
                        "${model.geoPointFlutter.distance(lat: location.latitude, lng: location.longitude).toInt()} km",
                        style: tt.caption,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
//        Wrap(
//          alignment: WrapAlignment.spaceBetween,
//          children: model.typesOfCuisine.map((typeOfCuisine) {
//            return TypeRestaurantView(typeOfCuisine: typeOfCuisine);
//          }).toList(),
//        ),
          Text(
            '${model.title}',
            style: theme.textTheme.headline,
          ),
        ],
      ),
    );
  }
}

class ReviewView extends StatelessWidget {
  final RestaurantModel model;

  const ReviewView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Text(
          model.priceRatingView ?? '€€',
          style: theme.textTheme.body2.copyWith(color: theme.errorColor),
        ),
        Text(
          " - (${model.reviewAverageVote ?? 4.5}",
          style: theme.textTheme.caption,
        ),
        Icon(
          Icons.star,
          color: theme.primaryColor,
        ),
        Text(
          ")", // su ${model.reviewsLenght ?? 147}",
          style: theme.textTheme.caption,
        )
      ],
    );
  }
}

class RestaurantsGridView extends StatelessWidget {
  final List<RestaurantModel> restaurants;

  const RestaurantsGridView({Key key, @required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: restaurants.length,
      gridDelegate: SliverStaggeredGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        staggeredTileBuilder: (_) => StaggeredTile.fit(1),
        staggeredTileCount: restaurants.length,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
      ),
      itemBuilder: (_, index) {
        final restaurant = restaurants[index];

        return InkWell(
          onTap: () {
            RestaurantBloc.init(RestaurantBloc(
              seedValue: restaurant,
              user: UserBloc.of().userBone.user,
            ));
            PocketRouter().push(context, RestaurantScreen.ROUTE);
          },
          child: RestaurantCellView(
            model: restaurant,
          ),
        );
      },
    );
  }
}

class RestaurantsBlankView extends StatelessWidget {
  const RestaurantsBlankView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Layout.vertical(
      padding: const EdgeInsets.all(64.0),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
            aspectRatio: 1,
            child: FittedBox(
                fit: BoxFit.fill,
                child: const Icon(
                  Icons.restaurant_menu,
                ))),
        Text(
          "Non è stato trovato nessun ristorante in questa categoria",
          style: theme.textTheme.title,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class RestaurantsGridBuilder extends StatelessWidget {
  final RestaurantsBloc _restaurantsBloc = RestaurantsBloc.of();

  @override
  Widget build(BuildContext context) {
    return ObservableBuilder<List<RestaurantModel>>(
      builder: (_, restaurants, state) {
        if (state.isBadState) return state.toWidget();

        if (restaurants.length == 0)
          return SingleChildScrollView(child: const RestaurantsBlankView());

        return RestaurantsGridView(
          restaurants: restaurants,
        );
      },
      stream: _restaurantsBloc.outRestaurants,
    );
  }
}
