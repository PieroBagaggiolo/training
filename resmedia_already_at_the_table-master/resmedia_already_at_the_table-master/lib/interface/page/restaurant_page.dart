import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pocket_map/pocket_map.dart';
import 'package:resmedia_already_at_the_table/data/config.dart';
import 'package:resmedia_already_at_the_table/generated/i18n.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/interface/view/types_restaurant_text.dart';
import 'package:resmedia_already_at_the_table/interface/widget/Menu.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_already_at_the_table/model/menu_model.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key key}) : super(key: key);
  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> with AutomaticKeepAliveClientMixin {
  final RestaurantBloc restaurantBloc = RestaurantBloc.of();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    final tt = theme.textTheme;

    return ObservableBuilder<Data2<RestaurantModel, List<MenuModel>>>(
      builder: (_, restaurantAndMenus, state) {
        if (state.isBadState) return state.toWidget();

        final restaurant = restaurantAndMenus.data1;
        final menus = restaurantAndMenus.data2;
        final ps = LatLng(
            restaurant.address.coordinates.latitude, restaurant.address.coordinates.longitude);

        return BoneProvider(
          bone: restaurantBloc.foodMenuBone,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 2,
                  child: SimpleSwiper(
                    itemCount: restaurant.imgs.length,
                    imgBuilder: (index) {
                      if (index == 0)
                        return CachedNetworkImageProvider(
                          restaurant.imgs[index],
                          cacheManager: CacheManager.monthTwo(),
                        );
                      return NetworkImage(restaurant.imgs[index]);
                    },
                    openScreen: (_context, screen) => PocketRouter().push(
                      _context,
                      "SimpleSwiper",
                      builder: (_) => screen,
                    ),
                  ),
                ),
              ),
              SliverListLayout.children(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Cfg.SPACE),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TypesRestaurantText(
                          typesOfCuisine: restaurant.typesOfCuisine,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          '${restaurant.title}',
                          style: tt.display1,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            restaurant.priceRatingView + " prezzo medio",
                            style: theme.textTheme.body2.copyWith(color: theme.errorColor),
                          ),
                        ),
                        Divider(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "${restaurant.reviewAverageVote} ",
                                  style: theme.textTheme.body2.copyWith(color: theme.primaryColor),
                                ),
                                SmoothStarRating(
                                  rating: 4.5,
                                  color: theme.primaryColor,
                                  size: theme.textTheme.body2.fontSize,
                                ),
                                Text(
                                  " su ${restaurant.reviewsLenght} voti",
                                  style: theme.textTheme.caption,
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                "leggi tutte",
                                style: theme.textTheme.overline.copyWith(color: theme.accentColor),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Paragraph(
                    title: Text("Descrizione"),
                    body: Text('${restaurant.description}'),
                  ),
                ],
                padding: const EdgeInsets.all(SPACE),
              ),
              SliverListLayout.children(
                children: [
                  Material(
                    elevation: 32.0,
                    child: Column(
                      children: <Widget>[
                        Horizontal(
                          left: ColorTitle(
                            color: cls.secondary,
                            child: Text("Dove siamo"),
                          ),
                          center: const SizedBox(
                            width: 16.0,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                      ],
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1.5,
                    child: PocketMapBuilder(
                      builder: (_, completer) {
                        return PocketMap(
                          onMapCreated: completer,
                          initialCameraPosition: CameraPosition(
                            target: ps,
                            zoom: 16.0,
                          ),
                          data: PocketMapData(
                            markers: {
                              Marker(
                                markerId: MarkerId(restaurant.address.addressLine),
                                position: ps,
                                infoWindow: InfoWindow(
                                  title: "${restaurant.title}",
                                ),
                              ),
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SliverListLayout.children(
                children: [
                  Paragraph(
                    title: Row(
                      children: <Widget>[
                        Text("Indirizzo"),
                        Icon(
                          Icons.location_on,
                          color: cls.primary,
                        ),
                      ],
                    ),
                    body: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(([
                          restaurant.address.thoroughfare,
                          restaurant.address.subThoroughfare,
                          restaurant.address.postalCode,
                        ]..removeWhere((v) => v == null))
                            .join(", ")),
                        Text(([
                          restaurant.address.locality,
                          restaurant.address.subAdminArea,
                          restaurant.address.adminArea,
                          restaurant.address.countryName,
                        ]..removeWhere((v) => v == null))
                            .join(", ")),
                        //Text("Marina di Torre Del Lago Viareggio (LU) 55049"),
                        //Text("Tel. +39 0584 359321"),
                        //Text("info.basilicofresco@gmail.com"),
                        Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                FontAwesomeIcons.facebookF,
                                color: cls.primary,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                FontAwesomeIcons.instagram,
                                color: cls.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Paragraph(
                    title: Text("Altre informazioni"),
                    body: InfoRestaurantView(
                      model: restaurant.info,
                    ),
                  ),
                ],
                padding: const EdgeInsets.all(SPACE),
              ),
              if (restaurantAndMenus.data2 != null) ...Menu.toList(menus: menus),
            ],
          ),
        );
      },
      stream: restaurantBloc.outRestaurantAndMenus,
    );
  }
}

class InfoRestaurantView extends StatelessWidget {
  final InfoRestaurantModel model;

  const InfoRestaurantView({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    final theme = Theme.of(context);
//    final tt = theme.textTheme;
//    final mediaQuery = MediaQuery.of(context);

    final list = <Widget>[
      ...model.general.map((info) => GeneralInfoView(info)),
      DressCodeInfoRestaurantView(
        values: model.dressCode,
      ),
      ParkingInfoView(
        model: model.parking,
      ),
    ];

    return StaggeredGridView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 2.0,
        staggeredTileBuilder: (_) => const StaggeredTile.fit(1),
        staggeredTileCount: list.length,
      ),
      children: list,
    );
  }
}

class GeneralInfoView extends StatelessWidget {
  final GeneralInfo value;

  const GeneralInfoView(this.value, {Key key}) : super(key: key);

  String _toString(BuildContext context) {
    final s = S.of(context);
    switch (value) {
      case GeneralInfo.airConditioned:
        return s.airConditioned_GeneralInfo;
      case GeneralInfo.wifi:
        return s.wifi_GeneralInfo;
      case GeneralInfo.cocktailBar:
        return "Cocktail Bar";
      case GeneralInfo.garden:
        return "Giardino esterno";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(_toString(context));
  }
}

class DressCodeInfoRestaurantView extends StatelessWidget {
  final List<DressCodeInfo> values;

  const DressCodeInfoRestaurantView({Key key, @required this.values}) : super(key: key);

  String _toString(S s, DressCodeInfo value) {
    switch (value) {
      case DressCodeInfo.elegant:
        return "elegante";
      case DressCodeInfo.casual:
        return "casual";
      case DressCodeInfo.sporty:
        return "sportivo";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        'Dress code consigliato: ${values.map((value) => _toString(S.of(context), value)).join(", ")}.');
  }
}

class DressCodeInfoView extends StatelessWidget {
  final DressCodeInfo value;

  const DressCodeInfoView(
    this.value, {
    Key key,
  }) : super(key: key);

  String _toString(S s) {
    switch (value) {
      case DressCodeInfo.elegant:
        return "elegante";
      case DressCodeInfo.casual:
        return "casual";
      case DressCodeInfo.sporty:
        return "sportivo";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Text(_toString(null));
  }
}

class ParkingInfoView extends StatelessWidget {
  final ParkingInfoModel model;

  const ParkingInfoView({Key key, @required this.model}) : super(key: key);

  String _propertyToString(S s) {
    switch (model.property) {
      case PropertyParking.private:
        return "privato";
      case PropertyParking.public:
        return "publico";
    }
    return "";
  }

  String _dimensionToString(S s) {
    switch (model.dimension) {
      case DimensionParking.small:
        return "piccolo";
      case DimensionParking.medium:
        return "medio";
      case DimensionParking.large:
        return "ampio";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Text("Parcheggio ${_propertyToString(s)} ${_dimensionToString(s)}");
  }
}

class PropertyParkingView extends StatelessWidget {
  final PropertyParking value;

  const PropertyParkingView(
    this.value, {
    Key key,
  }) : super(key: key);

  String _toString(S s) {
    switch (value) {
      case PropertyParking.private:
        return "privato";
      case PropertyParking.public:
        return "publico";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Text(_toString(null));
  }
}

class DimensionParkingView extends StatelessWidget {
  final DimensionParking value;

  const DimensionParkingView(
    this.value, {
    Key key,
  }) : super(key: key);

  String _toString(S s) {
    switch (value) {
      case DimensionParking.small:
        return "piccolo";
      case DimensionParking.medium:
        return "medio";
      case DimensionParking.large:
        return "ampio";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Text(_toString(null));
  }
}

//class RestaurantPage extends StatefulWidget {
//
//  const RestaurantPage({Key key}) : super(key: key);
//
//  @override
//  _RestaurantPageState createState() => _RestaurantPageState();
//}
//
//class _RestaurantPageState extends State<RestaurantPage> {
//  RestaurantBloc _restaurantBloc = RestaurantBloc.of();
//
//  @override
//  Widget build(BuildContext context) {
//    final theme = Theme.of(context);
//    final cls = theme.colorScheme;
//    final tt = theme.textTheme;
//
//    return CacheStreamBuilder<RestaurantModel>(
//      stream: _restaurantBloc.outRestaurant,
//      builder: (_context, snap) {
//        final model = snap.data;
//
//        if (!snap.hasData)
//          return Center(child: CircularProgressIndicator());
//
//        return RestaurantVoidPage(
//          leftButton: RaisedButton(
//            color: cls.secondaryVariant,
//            onPressed: () => DefaultNavigationController.of(context).index = 2,
//            child: FittedText("Sfoglia il menu"),
//          ),
//          rightButton: RaisedButton(
//            onPressed: () => PocketRouter().push(context, CreateTableScreen.ROUTE),
//            child: FittedText("Prenota e Ordina"),
//          ),
////          header: SimpleSwiper(
////            itemCount: model.imgs.length,
////            imgBuilder: (index) {
////              if (index == 0)
////                return CachedNetworkImageProvider(model.imgs[index],
////                  cacheManager: CacheManager.monthTwo(),
////                );
////              return NetworkImage(model.imgs[index]);
////            },
////            openScreen: (_context, screen) => PocketRouter().push(_context, "SimpleSwiper",
////              builder: (_) => screen,
////            ),
////          ),
//          //title: Text('${model.title}', style: tt.display1,),
////          price: Text(model.priceRatingView + " prezzo medio",
////            style: theme.textTheme.body2.copyWith(color: theme.errorColor),
////          ),
//          numRating: Text("${model.reviewAverageVote} ",
//            style: theme.textTheme.body2.copyWith(color: theme.primaryColor),),
//          star: SmoothStarRating(
//            rating: 4.5,
//            color: theme.primaryColor,
//            size: theme.textTheme.body2.fontSize,
//          ),
//          numReview: Text(" su ${model.reviewsLenght} voti", style: theme.textTheme.caption,),
//          description: Text('${model.description}'),
//          //categories: TypesRestaurantText(typesOfCuisine: model.typesOfCuisine,),
//          position: PocketMapBuilder(
//            builder: (_, completer) {
//              return PocketMap(
//                onMapCreated: completer,
//                initialCameraPosition: CameraPosition(
//                  target: model.position,
//                  zoom: 16.0,
//                ),
//                data: PocketMapData(
//                  markers: {Marker(
//                    markerId: MarkerId("_geoloc"),
//                    position: model.position,
//                    infoWindow: InfoWindow(
//                      title: "${model.title}",
//                    ),
//                  )}
//                ),
//              );
//            },
//          ), // TODO: Image.asset(model.id == 'mXBISsiLPARxJAUgtfuR' ? Img.POSITION_ADDRESS_INFORMATION : Md.POSITION),
//        );
//      }
//    );
//  }
//}
