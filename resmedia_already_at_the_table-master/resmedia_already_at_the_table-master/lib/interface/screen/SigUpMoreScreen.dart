import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pocket_map/pocket_map.dart';
import 'package:resmedia_already_at_the_table/interface/widget/Sign.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_already_at_the_table/main.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';

class SignUpMoreScreen extends StatefulWidget {
  static const ROUTE = "SignUpMoreScreen";

  const SignUpMoreScreen({
    Key key,
  }) : super(key: key);

  @override
  _SignUpMoreScreenState createState() => _SignUpMoreScreenState();
}

class _SignUpMoreScreenState extends State<SignUpMoreScreen> with SubscribeStateMixin {
  final SignUpMoreBloc _submitBloc = SignUpMoreBloc.of();

  @override
  void initState() {
    super.initState();
    subscribe = _submitBloc.outEvent.listen((event) async {
      if (event is CompletedEvent<UserModel>) {
        final user = event.values.first;
        PocketRouter()
            .pushAndRemoveAll(context, await calculatePage(user.firebaseUser, user: user));
      }
    });
  }

  @override
  void dispose() {
    SignUpMoreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: FormProvider(
        child: SignBackground(
          automaticallyImplyLeading: false,
          separator: const SizedBox(height: 16),
          children: <Widget>[
            NominativeFieldShell(
              bone: _submitBloc.nominativeFieldBone,
            ),
            PlaceFieldShell(
              bone: _submitBloc.placeFieldBone,
            ),
            TextFieldShell.phoneNumber(
              bone: _submitBloc.phoneNumberFieldBone,
            ),
            ButtonFieldShell(
              bone: _submitBloc.buttonFieldBone,
              child: FittedText("Salva"),
            ),
          ],
        ),
      ),
    );
  }
}
