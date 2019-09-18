import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_already_at_the_table/interface/screen/TableScreen.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableEditBloc.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';
import 'package:resmedia_already_at_the_table/model/restaurant_model.dart';
import 'package:intl/intl.dart' show DateFormat;

class CreateTableScreen extends StatefulWidget {
  static const String ROUTE = "CheckTableScreen";

  @override
  _CreateTableScreenState createState() => _CreateTableScreenState();
}

class _CreateTableScreenState extends State<CreateTableScreen> {
  final _restaurantBloc = RestaurantBloc.of();
  final _tableEditBloc = TableEditBloc.of();

  StreamSubscription _subscription;

  @override
  void dispose() {
    TableEditBloc.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscription?.cancel();
    _tableEditBloc.outEvent.listen((event) {
      if (event is TableEditEvent) {
        _solver(event.refTable, event.isOrder);
      }
    });
  }

  Future<void> _solver(DocumentReference tableRef, bool isOrder) async {
    if (tableRef == null)
      _showDialog(context);
    else if (isOrder) {
      TableBloc.init(TableBloc(TableModel(reference: tableRef)));
      await PocketRouter().popAndPush(context, TableScreen.ROUTE);
    } else {
      PocketRouter().popUntil(context, RestaurantScreen.ROUTE);
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text("Errore"),
          content: Layout.vertical(
            padding: const EdgeInsets.all(8.0),
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Il ristorante non ha tavoli disponibili nella data e orario richiesto",
                style: theme.textTheme.body2,
              ),
              Text(
                "Procedi con altra richiesta",
                style: theme.textTheme.overline,
              ),
              RaisedButton(
                onPressed: () => Navigator.pop(context),
                child: FittedText("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;

    return FormProvider(
      child: CheckTableVoid(
        titleRestaurant: ObservableBuilder<RestaurantModel>(
          builder: (context, restaurant, _) {
            return Text("${restaurant.title.text}");
          },
          stream: _restaurantBloc.outRestaurant,
        ),
        tableName: TextFieldShell(
          bone: _tableEditBloc.titleFieldBone,
        ),
        countPerson: TextFieldShell(
          bone: _tableEditBloc.countPersonFieldBone,
        ),
        orderTable: ButtonFieldShell(
          bone: _tableEditBloc.orderTableFieldBone,
          color: cls.secondaryVariant,
          child: FittedText("Prenota e Ordina il Menu"),
        ),
      ),
    );
  }
}

class CheckTableVoid extends StatelessWidget {
  final _tableEditBloc = TableEditBloc.of();
  final Widget titleRestaurant, tableName, countPerson, orderTable;

  CheckTableVoid({
    Key key,
    @required this.titleRestaurant,
    @required this.tableName,
    @required this.countPerson,
    @required this.orderTable,
  }) : super(key: key);

  Widget _inputField(String title, Widget field, ThemeData theme) {
    return Layout.vertical(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: theme.textTheme.subtitle,
          ),
        ),
        field,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
//    final cls = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Prenota Tavolo"),
      ),
      body: Layout.vertical(
        children: [
          Card(
            margin: const EdgeInsets.all(SPACE),
            child: Padding(
              padding: const EdgeInsets.all(SPACE),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Paragraph(
                        title: Text(
                          "Nome del ristorante",
                          style: theme.textTheme.subtitle,
                        ),
                        body: DefaultTextStyle(
                          style: theme.textTheme.headline,
                          child: titleRestaurant,
                        ),
                      ),
                      Divider(),
                      _inputField("Nome del tavolo", tableName, theme),
                      Row(
                        children: <Widget>[
                          Flexible(
                              flex: 2,
                              child: _inputField(
                                "Data e Ora",
                                DateTimeFieldShell(
                                  bone: _tableEditBloc.dateTimeFieldBone,
                                  pickerFormat: DateFormat('EEEE d MMMM HH:mm'),
                                ),
                                theme,
                              )),
                          Flexible(
                            flex: 1,
                            child: _inputField("Ospiti", countPerson, theme),
                          ),
                        ],
                      ),

                      /*SizedBox(height: SPACE,),
                    Center(
                      child: RaisedButton(
                        onPressed: () => _showDialog(context),
                        child: FittedText("Controlla Disponibilità"),
                      ),
                    ),*/
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: orderTable,
                  ),
                ],
              ),
            ),
          ),
        ],
        scrollPocket: ScrollPocket(),
      ),
    );
  }
}

/*Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 16,),

                    SizedBox(height: 16,),
                    RaisedButton(
                      //color: cls.secondaryVariant,
                      onPressed: () => EasyRouter.push(context, TableScreen()),
                      child: FittedText("Invita persone al Tavolo"),
                    )
                  ],
                ),*/
