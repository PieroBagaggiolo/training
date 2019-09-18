import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/screen/TableScreen.dart';
import 'package:resmedia_already_at_the_table/interface/view/BookingView.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableBloc.dart';
import 'package:resmedia_already_at_the_table/logic/skeletons/Booking.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final cls = theme.colorScheme;

    final bookingBone = BoneProvider.of<BookingBone>(context, false);

    return CustomScrollView(
      slivers: <Widget>[
        SliverContainer.adapter(
          padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
          child: Horizontal(
            left: ColorTitle(
              child: FittedText("Attive"),
            ),
          ),
        ),
        ObservableBuilder<List<TableModel>>(
          stream: bookingBone.outAfterTables,
          builder: (_context, tables, state) {
            if (state.isBadState) return state.toSliver();

            if (tables.length < 1)
              return SliverToBoxAdapter(child: Center(child: Text("Nessuna prenotazione")));

            return SliverListLayout(
              padding: const EdgeInsets.symmetric(horizontal: SPACE),
              childCount: tables.length,
              builder: (_, index) {
                final table = tables[index];

                return InkWell(
                  onTap: () {
                    TableBloc.init(TableBloc(table));
                    PocketRouter().push(context, TableScreen.ROUTE);
                  },
                  child: BookingCardView(
                    model: table,
                  ),
                );
              },
            );
          },
        ),
        ObservableBuilder<List<TableModel>>(
          stream: bookingBone.outBeforeTables,
          builder: (_context, tables, state) {
            if (state.isBadState) return state.toSliver();

            if (tables.length < 1)
              return SliverToBoxAdapter(
                child: const SizedBox(),
              );

            return SliverListLayout.childrenBuilder(
              separator: const SizedBox(
                height: 8.0,
              ),
              childCount: tables.length + 1,
              builder: (_, index) {
                if (index < 1)
                  return Horizontal(
                    left: ColorTitle(
                      color: cls.secondaryVariant,
                      child: FittedText("Archivio"),
                    ),
                  );

                final table = tables[index - 1];

                return InkWell(
                  onTap: () {
                    TableBloc.init(TableBloc(table));
                    PocketRouter().push(context, TableScreen.ROUTE);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: SPACE),
                    child: BookingCardView(
                      model: table,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

/*class BookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Horizontal(
          left: ColorTitle(color: theme.primaryColor, child: Text("Prenotazione")),),
        _body(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Nome del Ristorante", style: theme.textTheme.subtitle,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Ristorante Basilico Fresco", style: theme.textTheme.title,),
            ),
            SizedBox(height: 8.0,),
            Text("Nome del Tavolo", style: theme.textTheme.subtitle,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Compleanno Nonna Antonia", style: theme.textTheme.body2,),
            ),
            SizedBox(height: 8.0,),
            _feature(
              Text("Data"),
              Text("14 Ottobre 2019", style: theme.textTheme.subtitle,),
            ),
            Row(
              children: <Widget>[
                _feature(
                  Text("Ora di Arrivo"),
                  Text("19:30", style: theme.textTheme.subtitle,),),
                SizedBox(width: 8.0,),
                _feature(
                  Text("N. Posti"),
                  Text("25", style: theme.textTheme.subtitle,),),
              ],
            ),
            _feature(
              Text("Tempo permanenza previsto"),
              Text("> 90", style: theme.textTheme.subtitle,),),
          ],
        ),),
        Horizontal(left: ColorTitle(child: Text("Ordine"))),
        _body(Column(
          children: <Widget>[
            _price(
              Text("Totale Ordine Menu e Bevande"),
              Text("€ 1.753"),
            ),
            _price(
              Text("Coperti x25 persone"),
              Text("€ 100"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                _price(
                  Text("Totale Ordine", style: theme.textTheme.title,),
                  Text("€ 1.240", style: theme.textTheme.title,),
                ),
                Text("iva inclusa", style: theme.textTheme.caption,),
              ],
            ),
          ],
        ),),

      ],
    );
  }

  Widget _body(Widget body) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: body,
    ),
  );

  Widget _feature(Widget key, Widget value) => Padding(
    padding: EdgeInsets.all(4.0),
    child: Row(
      children: <Widget>[
        key,
        SizedBox(width: 4.0,),
        value,
      ],
    ),
  );

  Widget _price(Widget key, Widget value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        key,
        value,
      ],
    ),
  );
}*/
