import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/backend/interface/screen/RegisterOwnerScreen.dart';
import 'package:resmedia_already_at_the_table/backend/interface/widget/FakeWidgets.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/simulation.dart';


class MorePageOwner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return ListTileTheme(
      style: ListTileStyle.drawer,
      child: ListViewSeparated(
        padding: const EdgeInsets.all(SPACE),
        separator: const Divider(),
        children: <Widget>[
          ListTile(
            title: Text("Ristorante visibile all'utente"),
            trailing: FakeSwitch(
              color: cls.secondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              textColor: Colors.white,
              onPressed: () {
                Sm.configure(isSimulation: true);
                PocketRouter().push(context, RegisterOwnerScreen.ROUTE,
                  builder: (_) => RegisterOwnerScreen(),
                );
              },
              child: Text("Modifica le informazioni del locale"),
            ),
          )
        ],
      ),
    );
  }
}
