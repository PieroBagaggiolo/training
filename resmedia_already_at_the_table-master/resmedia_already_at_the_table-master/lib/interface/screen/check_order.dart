import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rational/rational.dart';
import 'package:resmedia_already_at_the_table/interface/view/BookingView.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/ChairBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';

class CheckOrderScreen extends StatelessWidget {
  static const String ROUTE = "CheckOrderScreen";

  final _userBloc = UserBloc.of();
  final _tableBloc = TableBloc.of();
  final _chairBloc = ChairBloc.of();

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text("Ti aspettiamo al tuo Tavolo!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Il pagamento è avvenuto con successo"),
              SizedBox(
                height: SPACE * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SPACE),
                child: RaisedButton(
                  color: theme.primaryColor,
                  onPressed: () => PocketRouter().popToHome(context),
                  child: FittedText("Ok"),
                ),
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
    final tt = theme.textTheme;
    final cls = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Conferma Ordine"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<TableModel>(
              stream: _tableBloc.outTable,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return BookingCardView(
                  model: snapshot.data,
                );
              },
            ),
          ),
          Horizontal(
            left: ColorTitle(
              color: cls.primary,
              child: Text("Ordine"),
            ),
          ),
          StreamBuilder<Rational>(
            stream: _chairBloc.outTotalPrice,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );

              final totalPrice = snapshot.data;

              final coveredPrice = Rational.fromInt(3);

              return Card(
                margin: const EdgeInsets.all(SPACE),
                child: Layout.vertical(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Totale ordine Menu e Bevande"),
                        PriceView(totalPrice),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Coperto"),
                        PriceView(coveredPrice),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Totale ordine",
                          style: tt.title,
                        ),
                        PriceView(
                          totalPrice + coveredPrice,
                          style: tt.title,
                        ),
                      ],
                    ),
                  ],
                  padding: const EdgeInsets.all(16.0),
                  separator: const SizedBox(
                    height: 8.0,
                  ),
                ),
              );
            },
          ),
          Horizontal(
            left: ColorTitle(
              color: theme.accentColor,
              child: Text("Pagamento tramite"),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StripePickSource(
                manager: _userBloc.stripeManager,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: RaisedButton(
              onPressed: () => openDialog(context),
              child: FittedText("Conferma"),
            ),
          ),
        ],
      ),
    );
  }
}
