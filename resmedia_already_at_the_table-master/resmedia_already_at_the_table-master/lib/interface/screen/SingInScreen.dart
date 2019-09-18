import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/generated/i18n.dart';
import 'package:resmedia_already_at_the_table/interface/screen/SignUpScreen.dart';
import 'package:resmedia_already_at_the_table/interface/widget/Sign.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_already_at_the_table/main.dart';

class SignInScreen extends StatefulWidget {
  static const String ROUTE = "SignInScreen";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInBloc _submitBloc = SignInBloc.of();

  @override
  void initState() {
    super.initState();
    _submitBloc.onResult = (res) async {
      if (res == null) return;
      await PocketRouter().pushAndRemoveAll(context, await calculatePage(res.user));
    };
  }

  @override
  void dispose() {
    SignInBloc.close();
    super.dispose();
  }

//  void _eventListener(event) async {
//    if (event is CompletedEvent<UserModel>) {
//      PocketRouter().push(context, calculatePage(event.values.first));
//    }
//  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final cls = theme.colorScheme;

    return FormProvider(
      child: SignWidget(
        fields: <Widget>[
          EmailFieldShell(
            bone: _submitBloc.emailFieldBone,
          ),
          PasswordFieldShell(
            bone: _submitBloc.passwordFieldBone,
          ),
        ],
        topButton: ButtonFieldShell(
          bone: _submitBloc.buttonFieldBone,
          child: FittedText(s.logIn),
        ),
        bottomButton: FlatButton(
          onPressed: () {
            PocketRouter().canPop(context)
                ? PocketRouter().pop(context)
                : PocketRouter().push(context, SignUpScreen.ROUTE);
          },
          child: FittedText(
            s.signUp,
            style: tt.button.copyWith(color: cls.secondary),
          ),
        ),
      ),
    );
  }
}
