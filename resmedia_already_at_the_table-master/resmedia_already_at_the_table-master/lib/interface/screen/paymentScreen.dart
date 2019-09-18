import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';

class PaymentScreen extends StatelessWidget {
  static const String ROUTE = 'PaymentScreen';

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
                  onPressed: () => PocketRouter().popUntil(context, RestaurantScreen.ROUTE),
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pagamento"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(64.0),
            child: Text(
              "Inserimento eventuali dati per il pagamento se previsti",
              style: theme.textTheme.body2,
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(SPACE),
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
