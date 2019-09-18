import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_already_at_the_table/backend/interface/page/BookingPageOwner.dart';
import 'package:resmedia_already_at_the_table/backend/interface/page/DishDayPageOwner.dart';
import 'package:resmedia_already_at_the_table/backend/interface/page/MorePageOwner.dart';

class HomeOwnerScreen extends StatelessWidget {
  static const ROUTE = 'HomeOwner';

  @override
  Widget build(BuildContext context) {
    return HomeVoidOwner();
  }
}

class HomeVoidOwner extends StatelessWidget {
  final List<Widget> pages = [
    BookingPageOwner(),
    DishDayPageOwner(),
    MorePageOwner(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: TabBarView(
          children: pages,
        ),
        bottomNavigationBar: DefaultTabBarBuilder(
          builder: (_context, currentIndex, onTapIndex) {
            return BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTapIndex,
              items: [
                BottomNavigationBarItem(
                  title: Text('Prenotazioni'),
                  icon: Icon(FontAwesomeIcons.checkCircle),
                ),
                BottomNavigationBarItem(
                  title: Text('Piatto del Giorno'),
                  icon: Icon(Icons.restaurant),
                ),
                BottomNavigationBarItem(
                  title: Text('Altro'),
                  icon: Icon(Icons.more_horiz),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
