import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:dash/dash.dart';
import 'package:resmedia_already_at_the_table/generated/provider.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Functions.dart';

class InviterBloc implements Bloc {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @protected
  @override
  void dispose() {}

  final Hand _emailHand = Hand();

  final FormHandler _emailFormHandler = FormHandler();

  GlobalKey<FormState> get emailFormKey => _emailFormHandler.formKey;

  EmailChecker _emailChecker;
  CheckerRule<String, String> get emailChecker => _emailChecker;

  SubmitController<int> emailSubmitController;

  Future<String> _idTable() async => TableBloc.of().value.id;

  Future<int> _onTapEmail() async {
    return await FbCloudFunctions().inviteToTable(await _idTable(), email: _emailChecker.value);
  }

  Future<int> inPhoneNumber(int phoneNumber) async {
    return await FbCloudFunctions().inviteToTable(
      await _idTable(),
      phoneNumber: phoneNumber,
    );
  }

  InviterBloc.instance() {
    _emailChecker = EmailChecker(hand: _emailHand);
    emailSubmitController =
        SubmitController(onSubmit: _onTapEmail, handler: _emailFormHandler, hand: _emailHand);
  }
  factory InviterBloc.of() => $Provider.of<InviterBloc>();
  static void close() => $Provider.dispose<InviterBloc>();
}
