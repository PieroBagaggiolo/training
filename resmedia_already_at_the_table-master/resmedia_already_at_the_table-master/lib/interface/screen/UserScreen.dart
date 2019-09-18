import 'package:easy_route/easy_route.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/main/MainWidgets.dart';
import 'package:resmedia_already_at_the_table/interface/widget/LogoutIconButton.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';


class UserScreen extends StatelessWidget {
  static const String ROUTE = "UserScreen";

  final _userBloc = UserBloc.of();

  @override
  Widget build(BuildContext context) {

    final user = _userBloc.userBone.user;

    return Scaffold(
      appBar: MainAppBar(
        title: Text("Il tuo Profilo"),
        actions: <Widget>[
          LogoutIconButton(),
        ],
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: Text('${user.nominative}'),
            subtitle: Text("Nominativo"),
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text("${user.email}"),
            subtitle: Text("E-Mail"),
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: Text("${user.phoneNumber}"),
            subtitle: Text("Numero di Telefono"),
          ),
          ListTile(
            onTap: () => PocketRouter().push(context, "StripeSourcesScreen",
              builder: (_) => StripeSourcesScreen(
                manager: _userBloc.stripeManager,
              ),
            ),
            leading: const Icon(Icons.credit_card),
            title: Text("Il tuo portafoglio"),
          ),
        ],
      ),
    );
  }
}
