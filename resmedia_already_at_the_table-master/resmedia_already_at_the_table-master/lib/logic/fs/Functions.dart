import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_already_at_the_table/model/TableModel.dart';

class FbCloudFunctions with AddStripeSourceMixin implements FunctionsFbBase {
  CloudFunctions get cf => CloudFunctions.instance;

  Future<int> inviteToTable(String idTable, {String email, int phoneNumber}) async {
    assert(email != null || phoneNumber != null);
    final prams = <String, dynamic>{
      'idTable': idTable,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber
    };

    try {
      final res = await cf.getHttpsCallable(functionName: "invitationToTable").call(prams);
      debugPrint(res.toString());
      switch (res.data['error']) {
        case 'INVALID_REQUEST':
          return -1;
        case 'NOT_EXIST_USER':
          return 0;
        case 'NOT_EXIST_TABLE':
          return -2;
        case 'NO_FREE_CHAIR':
          return -3;
        default:
          return res.data['successCount'];
      }
    } on CloudFunctionsException catch (exc) {
      print('${exc.code} \n::: ${exc.message}\n:::${exc.details}');
      return -1;
    }
  }

  Future<void> responseInvite(ChairModel chair, bool isAccept) async {
    await cf.getHttpsCallable(functionName: 'callResponseInvitationToTable').call({
      'pathChair': chair.path,
      'isAccept': isAccept,
    });
    print("responseInvite(chair: $chair, isAccept: $isAccept");
  }

  Future<void> joinInTheTable({
    @required String restaurantId,
    @required String tableId,
    @required String userNominative,
  }) async {
    await cf.getHttpsCallable(functionName: 'joinInTheTable').call({
      'restaurantId': restaurantId,
      'tableId': tableId,
      'userNominative': userNominative,
    });
  }
}
