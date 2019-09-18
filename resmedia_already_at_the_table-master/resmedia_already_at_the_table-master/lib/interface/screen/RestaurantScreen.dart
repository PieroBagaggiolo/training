import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_already_at_the_table/data/icons/res_media_icons.dart';
import 'package:resmedia_already_at_the_table/interface/page/booking_page.dart';
import 'package:resmedia_already_at_the_table/interface/page/menu_page.dart';
import 'package:resmedia_already_at_the_table/interface/page/promo_page.dart';
import 'package:resmedia_already_at_the_table/interface/page/restaurant_page.dart';
import 'package:resmedia_already_at_the_table/interface/page/review_page.dart';
import 'package:resmedia_already_at_the_table/interface/screen/CreateTableScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/ProductScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/TableScreen.dart';
import 'package:resmedia_already_at_the_table/interface/widget/BottonBarButton.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/FoodBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantBloc.dart';

class RestaurantScreen extends StatefulWidget {
  static const ROUTE = 'RestaurantScreen';

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> with SubscribeStateMixin {
  final RestaurantBloc _restaurantBloc = RestaurantBloc.of();

  ScrollItems<BottomNavigationBarItem> _pageItems;

  @override
  void initState() {
    super.initState();
    _pageItems = ScrollItems({
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text("Ristorante"),
      ): RestaurantPage(),
      const BottomNavigationBarItem(
        icon: Icon(ResMedia.promo),
        title: Text("Promo"),
      ): PromoPage(),
      const BottomNavigationBarItem(
        icon: Icon(Icons.restaurant_menu),
        title: Text("Menu"),
      ): MenuPageClient(),
      const BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.checkCircle),
        title: Text("Prenotazioni"),
      ): BoneProvider(
        bone: _restaurantBloc.bookingBone,
        child: BookingPage(),
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.star),
        title: Text("Recensisci"),
      ): ReviewPage(),
    });
    subscribe = _restaurantBloc.outEvent.listen((event) {
      if (event is TapFoodEvent) {
        FoodBloc.init(FoodBloc(
          seedValue: event.product,
          chairBloc: null,
        ));
        PocketRouter().push(context, FoodScreen.ROUTE);
      }
    });
  }

  @override
  void dispose() {
    RestaurantBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    //final cls = theme.colorScheme;
    //final tt = theme.textTheme;

    return DefaultNavigationController(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Dettaglio Ristorante"),
        ),
        body: NavigationView(children: _pageItems.views),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BottomBarButton(
              onPressed: () => PocketRouter().push(
                context,
                TableScreen.ROUTE,
                builder: (_) => CreateTableScreen(),
              ),
              child: FittedText("Crea il tuo Tavolo"),
            ),
            NavigationBar(
              type: BottomNavigationBarType.fixed,
              items: _pageItems.indicators,
            ),
          ],
        ),
      ),
    );
  }
}
