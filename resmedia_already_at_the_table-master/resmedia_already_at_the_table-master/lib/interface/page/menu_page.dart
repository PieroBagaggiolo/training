import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:resmedia_already_at_the_table/interface/widget/Menu.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantBloc.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:resmedia_already_at_the_table/model/menu_model.dart';


class MenuPageClient extends StatelessWidget {
  final restaurantBloc = RestaurantBloc.of();

  @override
  Widget build(BuildContext context) {
      return ObservableBuilder<List<MenuModel>>(builder: (_, menus, state) {
        if (state.isBadState)
          return state.toWidget();

        return BoneProvider(
          bone: restaurantBloc.foodMenuBone,
          child: CustomScrollView(
            slivers: Menu.toList(menus: menus),
          ),
        );
      }, stream: restaurantBloc.foodMenuBone.outMenus,);
//    return DefaultTabController(
//      length: 2,
//      child: Scaffold(
//        appBar: TabBar(
//          tabs: [
//            Tab(text: "Menu",),
//            Tab(text: "Drink",),
//          ],
//        ),
//        body: TabBarView(
//          children: [
//            ObservableBuilder<List<MenuModel>>((_, menus, state) {
//              if (menus == null) {
//                return state.toWaitWidget();
//              }
//
//              return BoneProvider(
//                bone: restaurantBloc.foodMenuBone,
//                child: CustomScrollView(
//                  slivers: Menu.toList(menus: menus),
//                ),
//              );
//            }, stream: restaurantBloc.drinkBone.outCategorized,),
//          ],
//        ),
//      ),
//    );
  }
}





/*class MenuPageViewClient extends StatelessWidget {
  final List<MainCategoryMenuModel> models;

  const MenuPageViewClient({Key key, @required this.models}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuPageVoid(
      children: models.asMap().map((index, mainCategory) {
        return MapEntry(
          Tab(text: '${mainCategory.title}'),
          MenuViewClient(
            models: mainCategory.values,
            builder: (pos, index) {
              switch (pos) {
                case ButtonTabPos.NEXT:
                  return 'Passa a ${models[index].title}';
                default:
                  return 'Not implemented';
              }
            },
          )
        );
      }),
    );
  }
}*/


class MenuPageVoid extends StatelessWidget {
  final Map<Tab, Widget> children;

  MenuPageVoid({Key key,
    @required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: children.length,
      child: Scaffold(
        appBar: TabBar(
          tabs: children.keys.toList(),
        ),
        body: TabBarView(
          children: children.values.toList(),
        ),
      ),
    );
  }
}


/*typedef String _BottomButtonBuilder(ButtonTabPos pos, int index);


class MenuViewClient extends StatelessWidget {
  final List<SubCategoryMenuModel> models;
  final _BottomButtonBuilder builder;

  const MenuViewClient({Key key,
    @required this.models,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuVoidClient(
      children: models.asMap().map((index, mainCategory) {
        return MapEntry(
          Text('${mainCategory.title}'),
          mainCategory.values.map((product) {
            return ProductCard(model: product,);
          }).toList(),
        );
      }),
      builder: (_context, pos, index) => FittedText(builder(pos, index)),
    );
  }
}


class MenuVoidClient extends StatelessWidget {
  final ChairBloc _cartBloc = ChairBloc.of();

  final Map<Widget, List<Widget>> children;
  final ButtonsTabBuilder builder;

  MenuVoidClient({Key key,
    @required this.children,
    @required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MenuVoid(
      children: children,
      sliversLast: <Widget> [
        SliverToBoxAdapter(
          child: Column(
            children: <Widget>[
              SizedBox(height: 16,),
              Container(color: theme.accentColor, height: 2,),
              Padding(
                padding: const EdgeInsets.only(
                  top: 32.0, left: 24.0,
                  right: 24.0, bottom: 24.0,
                ),
                child: NavigationButtons(
                  builder: (_context, pos, index) {
                    final text = builder(_context, pos, index);
                    switch (pos) {
                      case ButtonTabPos.BACK: case ButtonTabPos.FIRST:
                        return RaisedButton(
                          onPressed: _cartBloc != null
                          ? () => EasyRouter.popUntil(context, RestaurantScreen.ROUTE)
                          : () => DefaultNavigationController.of(context).index = 0,
                          child: FittedText("Torna Ristorante"),
                        );
                      case ButtonTabPos.NEXT:
                        final _control = DefaultTabController.of(_context);
                        return RaisedButton(
                          onPressed: () => _control.index = _control.index+1,
                          child: text,
                        );
                      case ButtonTabPos.LAST: {
                        if (_cartBloc == null)
                          return RaisedButton(
                            onPressed: () => EasyRouter.push(context, CreateTableScreen()),
                            child: FittedText("Prenota e Ordina"),
                          );

                        return RaisedButton(
                          onPressed: () => EasyRouter.push(context, CheckOrderScreen()),
                          child: FittedText("Conferma Ordina"),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}*/


class MenuVoid extends StatelessWidget {
  final Map<Widget, List<Widget>> children;
  final List<Widget> sliversFirst, sliversLast;

  MenuVoid({Key key,
    @required this.children, this.sliversLast: const [], this.sliversFirst: const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomScrollView(
      slivers: children.keys.map<Widget>((group) {
        final products = children[group];
        return SliverStickyHeader(
          header: Container(
            color: theme.canvasColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 16.0, bottom: 8.0),
                  child: DefaultTextStyle(
                    style: theme.textTheme.title.copyWith(color: theme.errorColor),
                    child: group,
                  ),
                ),
                Container(color: theme.primaryColor, height: 2.0,)
              ],
            ),
          ),
          sliver: SliverFixedExtentList(
            itemExtent: 128.0,
            delegate: SliverChildListDelegate(
              products,
            ),
          ),
        );
      }).toList()..addAll(sliversLast),
    );
  }
}




/// DELETE




enum ButtonTabPos {
  FIRST, BACK, NEXT, LAST,
}

typedef Widget ButtonsTabBuilder(BuildContext context, ButtonTabPos pos, int index);

@deprecated
class NavigationButtonsTab extends StatelessWidget {
  final List<Widget> pages;
  final Widget value;
  final ButtonsTabBuilder builder;

  NavigationButtonsTab({Key key,
    @required this.pages, @required this.value,
    @required this.builder,
  }) :
    assert(pages != null, "Please pass the tabs use"),
    assert(value != null, "Please pass the current Tab"),
    assert(builder != null),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    final num = pages.indexOf(value);
    final left = builder(context,  num == 0 ? ButtonTabPos.FIRST : ButtonTabPos.BACK, num);
    final right = builder(context, num+1 == pages.length ? ButtonTabPos.LAST : ButtonTabPos.NEXT, num);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: left == null || right == null ?
      [Expanded(child: left??right,)] :
      [
        Expanded(child: left),
        SizedBox(width: 16,),
        Expanded(child: right),
      ],
    );
  }
}


class NavigationButtons extends StatefulWidget {
  final ButtonsTabBuilder builder;

  NavigationButtons({Key key,
    @required this.builder,
  }) :
    assert(builder != null),
    super(key: key);

  @override
  _NavigationButtonsState createState() => _NavigationButtonsState();
}

class _NavigationButtonsState extends State<NavigationButtons> {
  TabController _tabController;
  int _length, _currentIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isInit = _tabController == null;
    _tabController?.removeListener(_setUpdate);
    _tabController = DefaultTabController.of(context);
    _tabController.addListener(_setUpdate);
    if(isInit) _update();
  }

  void _setUpdate() => setState(_update);

  void _update() {
    _length = _tabController.length;
    _currentIndex = _tabController.index;
  }

  @override
  void dispose() {
    _tabController.removeListener(_setUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;

    final left = widget.builder(context,  _currentIndex == 0 ? ButtonTabPos.FIRST : ButtonTabPos.BACK, _currentIndex);
    final right = widget.builder(context, _currentIndex+1 == _length ? ButtonTabPos.LAST : ButtonTabPos.NEXT, _currentIndex);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: left == null || right == null ? [
        Expanded(child: left??right,),
      ] : [
        ButtonTheme.fromButtonThemeData(
          data: theme.buttonTheme.copyWith(buttonColor: cls.secondaryVariant),
          child: Expanded(child: left),
        ),
        SizedBox(width: 16,),
        Expanded(child: right),
      ],
    );
  }
}
