import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/screen/MenuScreen.dart';
import 'package:resmedia_already_at_the_table/interface/view/BookingView.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/ChairBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'package:share/share.dart';

class TableScreen extends StatefulWidget {
  static const ROUTE = "TableScreen";

  @override
  _TableScreenState createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen>
    with BlocScreenStateMixin<TableScreen, TableBloc>, ThemeMixin, ScaffoldBuild {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Future<void> eventListener(event) async {
    if (event is JoinInTheTableEvent) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Sei entrato nel tavolo di ${event.titleTable}"
            " del ristorante ${event.titleRestaurant}"),
      ));
    }
  }

  Future<void> _onTapInvitation() async {
    final event = await bloc.shareInvite();
    await Share.share("Ho appena prenotato al ristorante ${event.titleRestaurant}"
        " a nome di ${event.titleTable}"
        " per partecipare clicca sul seguente link\n${event.url}");
  }

  Future<void> _showChairScreen(ChairModel chair) async {
    ChairBloc.init(ChairBloc(chair, bloc.value.idRestaurant));
    await PocketRouter().push(context, MenuScreen.ROUTE);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ObservableBuilder<TableModel>(
      stream: bloc.outTable,
      builder: (context, table, update) {
        if (update.isBadState) return update.toWidget();

        return Scaffold(
          key: _scaffoldKey,
          appBar: buildAppBar(context),
          body: buildBody(context, table: table),
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text("Tavolo"),
      actions: <Widget>[
//        ObservableBuilder<ChairModel>(
//          builder: (context, chair, update) {
//            if (update.isBadState) return const SizedBox();
//
//            return IconButton(
//              onPressed: () => bloc.cancelInvite(chair),
//              icon: const Icon(Icons.exit_to_app),
//            );
//          },
//          stream: bloc.outMyChair,
//        ),
      ],
    );
  }

  Widget buildBody(BuildContext context, {@required TableModel table}) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverContainer.adapter(
          padding: const EdgeInsets.all(SPACE),
          child: BookingCardView(model: table),
        ),
        SliverContainer.adapter(
          padding: const EdgeInsets.symmetric(horizontal: SPACE),
          child: Text(
            "Chi Siamo al Tavolo?",
            style: theme.textTheme.title,
          ),
        ),
        ObservableBuilder<List<ChairModel>>(
          stream: bloc.outChairs,
          builder: (context, chairs, update) {
            if (update.isBadState || chairs.length == 0) return update.toSliver();

            return SliverListLayout.childrenBuilder(
              surround: true,
              childCount: chairs.length,
              padding: const EdgeInsets.symmetric(horizontal: SPACE),
              separator: const Divider(),
              builder: (_, index) {
                return ItemTableView(
                  index: index + 1,
                  model: chairs[index],
                );
              },
            );
          },
        ),
        SliverContainer.adapter(
          padding: const EdgeInsets.all(SPACE),
          child: ObservableBuilder<ChairModel>(
            stream: bloc.outMyChair,
            builder: (context, chair, update) {
              if (update.isBadState) return update.toWidget();

              return DoubleWidget(
                left: FutureCallBack.raisedButton(
                  color: cls.secondaryVariant,
                  onPressed: _onTapInvitation,
                  child: FittedText("Invita"),
                ),
                separator: const SizedBox(width: 16.0),
                right: FutureCallBack.raisedButton(
                  onPressed: () => _showChairScreen(chair),
                  child: FittedText("Ordina"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ItemTableView extends StatelessWidget {
  final userBloc = UserBloc.of();
  final tableBloc = TableBloc.of();
  final ChairModel model;
  final int index;

  ItemTableView({
    Key key,
    @required this.model,
    @required this.index,
  }) : super(key: key);

  Future<void> _orderMenu(BuildContext context) async {
    ChairBloc.init(ChairBloc(model, tableBloc.value.idRestaurant));
    await PocketRouter().push(context, MenuScreen.ROUTE);
  }

  Future<void> _showMenu(BuildContext context) async {
    ChairBloc.init(ChairBloc(model, tableBloc.value.idRestaurant, isActiveCart: false));
    await PocketRouter().push(context, MenuScreen.ROUTE);
  }

  Future<void> _payament(BuildContext context) async {}
  Future<void> _cancelInvite(BuildContext context) async {
    await tableBloc.cancelInvite(model);
  }

  Widget itemBuild(
    BuildContext context, {
    @required AsyncContextCallBack onPressed,
    @required String action,
  }) {
    return Layout.horizontal(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        Text("$index"),
        const SizedBox(width: 16.0),
        Layout.horizontal(
          expanded: true,
          children: [
            Text(
              model.nominative ?? "",
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 16.0),
            FlatButton(
              onPressed: () => onPressed(context),
              child: Text(action),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMyChair = model.user == userBloc.userBone.user.id;

    if (model.products == null)
      return itemBuild(
        context,
        action: "Anulla",
        onPressed: _cancelInvite,
      );

    switch (model.menuState) {
      case MenuStatus.OPEN:
        {
          return itemBuild(
            context,
            action: isMyChair || model.isFree ? "Ordina" : "Visualizza",
            onPressed: isMyChair ? _orderMenu : _showMenu,
          );
        }
      case MenuStatus.CLOSED:
        {
          return itemBuild(
            context,
            action: model.isFree ? "Paga" : "Offri",
            onPressed: _payament,
          );
        }
      case MenuStatus.ORDERED:
        {
          return itemBuild(
            context,
            action: "Ordinato",
            onPressed: _orderMenu,
          );
        }
      default:
        return const SizedBox();
    }
  }
}

//class TableScreen extends StatefulWidget {
//  static const ROUTE = "TableScreen";
//
//  @override
//  _TableScreenState createState() => _TableScreenState();
//}
//
//class _TableScreenState extends State<TableScreen> {
//  final TableBloc _tableBloc = TableBloc.of();
//
//  @override
//  void dispose() {
//    TableBloc.close();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final theme = Theme.of(context);
//    final cls = theme.colorScheme;
//
//    return ObservableBuilder<TableModel>((context, table, update) {
//      if (update.isBadState)
//        return update.toWidget();
//
//      return TableViewScreen(
//        model: table,
//        sliverChairs: ObservableBuilder<List<ChairModel>>((context, chair, update) {
//          if (update.isBadState)
//            return update.toSliver();
//
//          return SliverList(
//            delegate: SliverListSeparatorDelegate.childrenBuilder((_, index) {
//              return ItemTableView(
//                sheet: chair[index],
//              );
//            },
//              startWithDivider: true,
//              childCount: chair.length,
//              separator: const Divider(),
//            ),
//          );
//        }, stream: _tableBloc.outOthersChairs),
//        button: ObservableBuilder<ChairModel>((context, chair, update) {
//          if (update.isBadState)
//            return update.toWidget();
//
//          return Row(
//            children: <Widget>[
//              Expanded(
//                child: FutureCallBack.raisedButton(
//                  color: cls.secondaryVariant,
//                  onPressed: () async {
//                    if (chair.products == null) {
//                      await _tableBloc.cancelInvite(chair);
//                    }
//                    await showDialog(
//                      context: context,
//                      builder: (_) => InviteSenderDialog(
//                        inviteBy: InviteBy.EMAIL,
//                      ),
//                    );
//                  },
//                  child: FittedText(chair.products == null ? "Rifiuta" : "Invita"),
//                ),
//              ),
//              SizedBox(width: 16.0,),
//              Expanded(
//                child: FutureCallBack.raisedButton(
//                  onPressed: () async {
//                    if (chair.products == null) {
//                      await _tableBloc.acceptInvite(chair);
//                    } else {
//                      ChairBloc.init(ChairBloc(chair, _tableBloc.value.idRestaurant));
//                      await PocketRouter().push(context, MenuScreen.ROUTE);
//                    }
//                  },
//                  child: FittedText(chair.products == null ? "Partecipa" : "Ordina"),
//                ),
//              ),
//            ],
//          );
//        }, stream: _tableBloc.outMyChair),
//      );
//    }, stream: _tableBloc.outTable);
//  }
//}
//
//
//class TableViewScreen extends StatelessWidget {
//  final TableModel model;
//  final Widget sliverChairs;
//  final Widget button;
//  final inviterBloc = InviterBloc.of();
//  final tableBloc = TableBloc.of();
//
//
//  TableViewScreen({Key key,
//    @required this.model,
//    @required this.sliverChairs, @required this.button,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    final theme = Theme.of(context);
//    //final cls = theme.colorScheme;
//    return Scaffold(
//      key: inviterBloc.scaffoldKey,
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text("Tavolo"),
//        actions: <Widget>[
//          ObservableBuilder<ChairModel>((context, chair, update) {
//            if (update.isBadState)
//              return const SizedBox();
//
//            return IconButton(
//              onPressed: () => tableBloc.cancelInvite(chair),
//              icon: const Icon(Icons.exit_to_app),
//            );
//          }, stream: tableBloc.outMyChair),
//        ],
//      ),
//      body: CustomScrollView(
//        slivers: <Widget>[
//          SliverPadding(
//            padding: const EdgeInsets.all(SPACE),
//            sliver: SliverToBoxAdapter(
//              child: BookingCardView(model: model,),
//            ),
//          ),
//          SliverPadding(
//            padding: const EdgeInsets.symmetric(horizontal: SPACE),
//            sliver: SliverToBoxAdapter(
//              child: Text("Chi Siamo al Tavolo?", style: theme.textTheme.title,),
//            ),
//          ),
//          SliverPadding(
//            padding: const EdgeInsets.symmetric(horizontal: SPACE),
//            sliver: sliverChairs,
//          ),
//          SliverPadding(
//            padding: const EdgeInsets.all(SPACE),
//            sliver: SliverToBoxAdapter(
//              child: button,
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//
//class ItemTableView extends StatelessWidget {
//  final tableBloc = TableBloc.of();
//  final ChairModel sheet;
//  ChairModel get model => sheet;
//
//  ItemTableView({Key key, @required this.sheet,}) : super(key: key);
//
//  Future<void> _openMenu(BuildContext context) async {
//    ChairBloc.init(ChairBloc(sheet, tableBloc.value.idRestaurant));
//    await PocketRouter().push(context, MenuScreen.ROUTE);
//  }
//  Future<void> _inviteUser(BuildContext context) async {
//    await showDialog(
//      context: context,
//      builder: (_) => InviteSenderDialog(inviteBy: InviteBy.EMAIL,),
//    );
//  }
//  Future<void> _payament(BuildContext context) async {
//
//  }
//  Future<void> _cancelInvite(BuildContext context) async {
//    await tableBloc.cancelInvite(model);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (model.products == null)
//      return SubItemChairView(
//        nominative: model.nominative, action: "Anulla",
//        onTap: (_) {}, onPressed: _cancelInvite,
//      );
//
//    switch (model.menuState) {
//      case MenuStatus.OPEN: {
//        return SubItemChairView(
//          nominative: model.nominative, action: "Ordina dal Menu",
//          onTap: model.isFree ? _inviteUser : _openMenu, onPressed: _openMenu,
//        );
//      }
//      case MenuStatus.CLOSED: {
//        return SubItemChairView(
//          nominative: model.nominative, action: model.isFree ? "Paga" : "Offri",
//          onTap: _openMenu, onPressed: _payament,
//        );
//      }
//      case MenuStatus.ORDERED: {
//        return SubItemChairView(
//          nominative: model.nominative, action: "Ordinato",
//          onTap: _openMenu, onPressed: _openMenu,
//        );
//      }
//      default: return const SizedBox();
//    }
//  }
//}
//
//
//typedef void VoidBuilder(BuildContext context);
//
//
//class SubItemChairView extends StatelessWidget {
//  final String nominative, action;
//  final AsyncContextCallBack onTap, onPressed;
//
//  const SubItemChairView({Key key,
//    @required this.nominative, @required this.action,
//    @required this.onTap, @required this.onPressed,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    final theme = Theme.of(context);
//    final cls = theme.colorScheme;
//
//
//    return ConstrainedBox(
//      constraints: BoxConstraints(minHeight: 64),
//      child: Row(
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          nominative == null ? RaisedButton(
//            onPressed: () => onTap(context),
//            color: cls.secondaryVariant,
//            child: FittedText("Invita"),
//          ) : Container(
//            height: 48,
//            decoration: BoxDecoration(
//                color: Colors.white,
//                borderRadius: BorderRadius.all(Radius.circular(8.0)),
//                border: Border.all(color: theme.dividerColor, )
//            ),
//            margin: const EdgeInsets.only(top: 16.0, left: 16.0, bottom: 16.0),
//            padding: const EdgeInsets.symmetric(horizontal: 16.0),
//            child: Align(
//              alignment: Alignment.centerLeft,
//              child: Text(nominative),
//            ),
//          ),
//          const SizedBox(width: 16.0,),
//          Expanded(
//            child: FutureCallBack.raisedButton(
//              onPressed: () async => await onPressed(context),
//              child: FittedText(action),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
