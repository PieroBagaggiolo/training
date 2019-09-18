import 'dart:async';

import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/LoginScreenOwner.dart';
import 'package:resmedia_already_at_the_table/export/ColumnDrawer.dart';
import 'package:resmedia_already_at_the_table/generated/i18n.dart';
import 'package:resmedia_already_at_the_table/interface/dialogs/FiltersDialog.dart';
import 'package:resmedia_already_at_the_table/interface/screen/RestaurantsScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/TableScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/UserScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/BookingScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/favorite_screen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_already_at_the_table/interface/view/RestaurantView.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/interface/view/types_restaurant_view.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/BookingBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/FiltersDialogBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableBloc.dart' as tb;
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/HomeBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Restaurant.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_already_at_the_table/r.dart';

class HomeScreen extends StatefulWidget {
  static const ROUTE = "HomeScreen";

  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const double SPACE_CELL = 8.0;

  final _userBloc = UserBloc.of();
  final _homeBloc = HomeBloc.init(HomeBloc());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScaffoldState get _scaffoldState => _scaffoldKey.currentState;

  StreamSubscription notificationSub;

  @override
  void initState() {
    _homeBloc.outEvent.listen(_eventListener);
    super.initState();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    notificationSub?.cancel();
    notificationSub = _userBloc.userBone.outNotification.listen((notification) async {
      print(notification);
      if (notification != null) {
        BookingBloc(user: UserBloc.of().userBone.user);
        PocketRouter().push(context, BookingScreen.ROUTE);
      }
    });
  }

  @override
  void dispose() {
    HomeBloc.close();
    UserBloc.close();
    super.dispose();
  }

  void _eventListener(event) async {
    if (event is JoinInTheTableEvent) {
      tb.TableBloc.init(tb.TableBloc.from(invitation: event.invitation));
      await (PocketRouter()..popToHome(context)).push(context, TableScreen.ROUTE);
    } else if (event is ReceiveInvitationEvent) {
      _scaffoldState.showSnackBar(SnackBar(
        content: Text("Stai per essere aggiunto al tavolo..."),
      ));
    }
  }

  void _showRestaurants() {
    RestaurantsBloc.init(RestaurantsBloc(repository: RepositoryBloc.of()));
    PocketRouter().push(context, RestaurantsScreen.ROUTE);
  }

  void showFilters() {
    FiltersDialogBloc.init(FiltersDialogBloc());
    showDialog<RestaurantFilters>(context: context, builder: (_) => FiltersDialog())
        .then((filters) {
      if (filters != null) {
        RestaurantsBloc.init(RestaurantsBloc(repository: RepositoryBloc.of(), filters: filters));
        PocketRouter().push(context, RestaurantsScreen.ROUTE);
      }
    });
  }

  void initSearch() {
    showSearch(context: context, delegate: RestaurantsSearcher());
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final cls = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: initSearch,
            icon: const Icon(Icons.search),
          ),
          TranslationButton(),
        ],
      ),
      drawer: HomeDrawer(),
      endDrawer: TranslationDrawer(
        locales: S.delegate.supportedLocales,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
            child: Image.asset(R.assetsImgLogo, fit: BoxFit.contain),
          ),
          Horizontal(
            left: InkWell(
              onTap: _showRestaurants,
              child: ColorTitle(
                icon: Icon(Icons.location_on),
                child: FittedText(s.nearby),
              ),
            ),
            center: const SizedBox(
              width: 8.0,
            ),
            right: InkWell(
              onTap: showFilters,
              child: ColorTitle(
                color: cls.secondaryVariant,
                icon: Icon(Icons.filter_list),
                child: FittedText(
                  s.filters,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SPACE),
            child: ObservableBuilder<List<RestaurantModel>>(
              builder: (context, restaurants, state) {
                if (state.isBadState) return state.toWidget();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: restaurants.getRange(0, 2).map<Widget>((restaurant) {
                    return Expanded(
                      child: InkWell(
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
                      ),
                    );
                  }).toList()
                    ..insert(
                      1,
                      SizedBox(
                        width: SPACE_CELL,
                      ),
                    ),
                );
              },
              stream: _homeBloc.outValue,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          ColorTitle(
            color: cls.primary,
            icon: Icon(Icons.restaurant_menu),
            child: FittedText(s.typesOfCuisine),
          ),
          TypesRestaurantListView(),
        ],
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  void _openBookingScreen(BuildContext context) async {
    BookingBloc.init(BookingBloc(user: UserBloc.of().userBone.user));
    PocketRouter().drawerPush(context, BookingScreen.ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    return ColumnDrawer(
      color: Colors.white,
      children: <Widget>[
        const SizedBox(height: 32),
        ItemDrawer(
          onTap: () => Navigator.pop(context),
          iconData: Icons.home,
          text: "HOME",
        ),
        ItemDrawer(
          onTap: () => PocketRouter().drawerPush(context, UserScreen.ROUTE),
          iconData: Icons.account_circle,
          text: "PROFILO",
        ),
        ItemDrawer(
          onTap: () => _openBookingScreen(context),
          iconData: FontAwesomeIcons.checkCircle,
          text: "PRENOTAZIONI",
        ),
        ItemDrawer(
          onTap: () => PocketRouter().drawerPush(
            context,
            FavoriteScreen.ROUTE,
          ),
          iconData: Icons.favorite_border,
          text: "PREFERITI",
        ),
        ItemDrawer(
          onTap: () => PocketRouter().drawerPush(context, OwnerLoginScreen.ROUTE),
          iconData: Icons.lock_outline,
          text: "AREA RISERVATA",
        ),
      ],
    );
  }
}

class ItemDrawer extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  final String text;

  const ItemDrawer({Key key, this.onTap, @required this.iconData, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget bottom;
    if (text != null) {
      final theme = Theme.of(context);
      bottom = DefaultTextStyle(
          style: theme.textTheme.body2.copyWith(color: theme.iconTheme.color), child: Text(text));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: CellTitle(
        onTap: onTap,
        center: Icon(
          iconData,
          size: 48,
          color: Colors.grey,
        ),
        bottom: bottom,
      ),
    );
  }
}

class RestaurantsSearcher extends SearchDelegate {
  RestaurantsBloc _restaurantsBloc = RestaurantsBloc.init(RestaurantsBloc(
    repository: RepositoryBloc.of(),
  ));

  void updateFilters(BuildContext context) {
    showFiltersDialog(context: context, filters: _restaurantsBloc.filters).then((filters) {
      if (filters != null) _restaurantsBloc.inFilters(filters);
    });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => updateFilters(context),
        icon: const Icon(Icons.filter_list),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _restaurantsBloc.inQuery(query);
    return RestaurantsGridBuilder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  @override
  void close(BuildContext context, result) {
    RestaurantsBloc.close();
    super.close(context, result);
  }
}

class CellTitle extends StatelessWidget {
  final VoidCallback onTap;
  final Widget center;
  final Widget bottom;

  const CellTitle({
    Key key,
    this.onTap,
    @required this.center,
    this.bottom,
  })  : assert(center != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = List<Widget>()..add(center);
    if (bottom != null) children.add(bottom);
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
