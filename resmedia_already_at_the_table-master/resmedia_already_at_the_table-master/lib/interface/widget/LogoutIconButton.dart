import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/interface/screen/SignUpScreen.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/logic/repository/SignRepository.dart';

class LogoutIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await UserBloc.of().userBone.logout();
        SignUpBloc.init(SignUpBloc(signRepository: SignRepository.of()));
        await PocketRouter().pushAndRemoveAll(context, SignUpScreen.ROUTE);
      },
      icon: const Icon(Icons.exit_to_app),
    );
  }
}
