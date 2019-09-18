import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/generated/i18n.dart';
import 'package:resmedia_already_at_the_table/interface/screen/SingInScreen.dart';
import 'package:resmedia_already_at_the_table/interface/widget/Sign.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_already_at_the_table/logic/repository/SignRepository.dart';
import 'package:resmedia_already_at_the_table/main.dart';

class SignUpScreen extends StatefulWidget {
  static const ROUTE = "SignUpScreen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpBloc _submitBloc = SignUpBloc.of();

  final FocuserPocket _pocket = FocuserPocket();

  @override
  void initState() {
//    _submitBloc.outEvent.listen(_eventListener);
    _submitBloc.onResult = (res) async {
      if (res == null) return;
      PocketRouter().push(context, await calculatePage(res.user));
    };
    super.initState();
  }

  @override
  void dispose() {
    SignUpBloc.close();
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
            focusNode: _pocket[_submitBloc.emailFieldBone],
          ),
          PasswordFieldShell(
            bone: _submitBloc.passwordFieldBone,
            focusNode: _pocket[_submitBloc.passwordFieldBone],
          ),
          RepeatPasswordFieldShell(
            bone: _submitBloc.repeatPasswordFieldBone,
            focusNode: _pocket[_submitBloc.repeatPasswordFieldBone],
            textInputAction: TextInputAction.done,
          ),
        ],
        topButton: ButtonFieldShell(
          bone: _submitBloc.buttonFieldBone,
          focusNode: _pocket[_submitBloc.buttonFieldBone],
          child: FittedText(s.signUp),
        ),
        bottomButton: FlatButton(
          onPressed: () {
            SignInBloc.init(SignInBloc(signRepository: SignRepository.of()));
            PocketRouter().push(context, SignInScreen.ROUTE);
          },
          child: FittedText(
            s.logIn,
            style: tt.button.copyWith(color: cls.secondary),
          ),
        ),
      ),
    );
  }
}
