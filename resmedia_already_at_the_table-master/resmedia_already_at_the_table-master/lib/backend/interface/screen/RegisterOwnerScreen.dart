import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/interface/page/RegisterMenuPage.dart';
import 'package:resmedia_already_at_the_table/backend/interface/page/RegisterRestaurantPage.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/HomeOwner.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/ProductScreenOwner.dart';
import 'package:resmedia_already_at_the_table/backend/logic/blocs/FoodEditBloc.dart';
import 'package:resmedia_already_at_the_table/backend/logic/blocs/RestaurantEditBloc.dart';
import 'package:resmedia_already_at_the_table/interface/page/menu_page.dart';
import 'package:resmedia_already_at_the_table/interface/widget/LogoutIconButton.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/model/products/FoodModel.dart';

class RegisterOwnerScreen extends StatefulWidget {
  static const ROUTE = 'RegisterOwnerScreen';

  @override
  _RegisterOwnerScreenState createState() => _RegisterOwnerScreenState();
}

class _RegisterOwnerScreenState extends State<RegisterOwnerScreen> with TickerProviderStateMixin {
  final _restaurantEditBloc = RestaurantEditBloc.of() ??
      RestaurantEditBloc.init(RestaurantEditBloc(user: UserBloc.of().userBone.user));

  final List<Widget> _pages = [
    //RegisterPageOwner(),
    RegisterRestaurantPageOwner(),
    MenuFoodPageViewOwner(),
    MenuDrinkPageViewOwner(),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    _restaurantEditBloc.outEvent.listen(_eventListener);
  }

  Future<void> _eventListener(event) async {
    if (event is NextTabEvent) {
      _tabController.index += 1;
    } else if (event is CompletedEvent) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text("Registrazione completata"),
              ));
    } else if (event is EditFood || event is NewFood) {
      if (event is EditFood)
        FoodEditBloc.init(FoodEditBloc(
          category: event.category,
          food: FoodModel.product(event.product),
        ));
      if (event is NewFood)
        FoodEditBloc.init(FoodEditBloc(
          category: event.category,
          restaurant: await _restaurantEditBloc.outRestaurant.first,
        ));
      PocketRouter().push(context, FoodScreenOwner.ROUTE);
    }
  }

  @override
  void dispose() {
    RestaurantBloc.close();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final theme = Theme.of(context);
    //final cls = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Registra il tuo account"),
        bottom: DefaultTabBarBuilder(
          builder: (context, currentIndex, onTap) {
            return ProgressTapBar.number(
              length: _pages.length,
              currentIndex: currentIndex,
              onTap: (_) {},
            );
          },
          controller: _tabController,
        ),
        actions: <Widget>[
          LogoutIconButton(),
          TranslationButton(),
        ],
      ),
      endDrawer: TranslationDrawer(
        locales: RepositoryBlocBase.of().supportedLocales,
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
      ),
    );
  }
}

class NavigationButtonsOwner extends NavigationButtons {
  NavigationButtonsOwner()
      : super(
          builder: (_context, pos, index) {
            switch (pos) {
              case ButtonTabPos.BACK:
                final _control = DefaultTabController.of(_context);
                return RaisedButton(
                  textColor: Colors.white,
                  onPressed: () => _control.index -= 1,
                  child: Text('Salva e Retrocedi'),
                );
              case ButtonTabPos.NEXT:
                final theme = Theme.of(_context);
                final _control = DefaultTabController.of(_context);
                return RaisedButton(
                  textColor: Colors.white,
                  color: theme.primaryColor,
                  onPressed: () => _control.index = _control.index + 1,
                  child: Text('Salva e Procedi'),
                );
              case ButtonTabPos.LAST:
                final theme = Theme.of(_context);
                return RaisedButton(
                  textColor: Colors.white,
                  color: theme.primaryColor,
                  onPressed: () => PocketRouter().pushReplacement(_context, HomeOwnerScreen.ROUTE),
                  child: Text('Salva e Procedi'),
                );
              default:
                return null;
            }
          },
        );
}
