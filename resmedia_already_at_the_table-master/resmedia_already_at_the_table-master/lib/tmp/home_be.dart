
/*import 'dart:async';

import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/interface/page/menu_page_be.dart';
import 'package:resmedia_already_at_the_table/tmp/restaurant_page_be.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/ProductScreenOwner.dart';
import 'package:resmedia_already_at_the_table/backend/logic/RestaurantBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:rxdart/rxdart.dart';


class HomeScreenBe extends StatefulWidget implements EasyRoute {
  static const ROUTE = '';
  String get route => ROUTE;

  @override
  _HomeScreenBeState createState() => _HomeScreenBeState();
}

class _HomeScreenBeState extends State<HomeScreenBe> {
  UserBloc userBloc;
  RestaurantBloc restaurantBloc;
  final List<Widget> pages = [
    RestaurantPageBe(),
    MenuFoodPageViewOwner(),
  ];
  PageControl _pageControl;

  @override
  void initState() {
    super.initState();
    userBloc = UserBloc.of();
    restaurantBloc = RestaurantBloc.of()..inUid(userBloc.outUser.map((user) => user.uid));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pageControl?.dispose();
    _pageControl = PageControl();
  }

  @override
  void dispose() {
    restaurantBloc.close();
    _pageControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserHandler>(
      stream: userBloc.outUser,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Material(child: Center(child: CircularProgressIndicator(),),);
        final user = snapshot.data;
        return HomeVoidScreenBe(
          endDrawerTitle: Text('${user.name}'),
          onTapAccount: () {},
          onTapNewFood: () => EasyRouter.push(context, FoodScreenBe()),
          pageBuilder: (_context, index) => pages[index],
          pageControl: _pageControl,
        );
      }
    );
  }
}


class PageControl {
  final StreamController<int> _pageControl;
  Stream<int> get outPage => _pageControl.stream;

  PageControl({int page: 0}) : this._pageControl = BehaviorSubject.seeded(page);

  void inPage(int page) {
    _pageControl.add(page);
  }

  void dispose() {
    _pageControl.close();
  }
}


class HomeVoidScreenBe extends StatelessWidget {
  final Widget endDrawerTitle;
  final List<Widget> endDrawerChildren;
  final VoidCallback onTapAccount, onTapNewFood;
  final PageControl pageControl;
  final IndexedWidgetBuilder pageBuilder;

  const HomeVoidScreenBe({Key key,
    this.endDrawerTitle, this.endDrawerChildren,
    this.onTapAccount, this.onTapNewFood,
    @required this.pageControl, @required this.pageBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Il Tuo Ristorante"),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: endDrawerTitle,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              onTap: onTapAccount,
              leading: Icon(Icons.account_circle),
              title: Text("Account"),
            ),
            ListTile(
              onTap: onTapNewFood,
              leading: Icon(Icons.add),
              title: Text("Crea un nuovo piatto"),
            ),
          ],
        ),
      ),
      body: StreamBuilder<int>(
        initialData: 0,
        stream: pageControl.outPage,
        builder: (context, snap) {
          return pageBuilder(context, snap.data);
        },
      ),
      bottomNavigationBar: StreamBuilder<int>(
        initialData: 0,
        stream: pageControl.outPage,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            onTap: pageControl.inPage,
            type: BottomNavigationBarType.fixed,
            currentIndex: snapshot.data,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("Ristorante"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                title: Text("Menu"),
              ),
            ],
          );
        }
      ),
    );
  }
}*/




