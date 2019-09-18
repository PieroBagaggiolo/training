import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/ChairEditBloc.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:resmedia_already_at_the_table/logic/bloc/TableBloc.dart';
import 'package:share/share.dart';

enum InviteBy {
  EMAIL, PHONE_NUMBER,
}


class InviteSenderDialog extends StatefulWidget {
  final InviteBy inviteBy;

  InviteSenderDialog({Key key, this.inviteBy,}) : super(key: key);

  @override
  _InviteSenderDialogState createState() => _InviteSenderDialogState();
}

class _InviteSenderDialogState extends State<InviteSenderDialog> {
  InviterBloc _inviterBloc;

  @override
  void initState() {
    _inviterBloc = InviterBloc.of();
    _inviterBloc.emailSubmitController.solver = (res) => _solver(context, res);
    super.initState();
  }

  @override
  void dispose() {
    InviterBloc.close();
    super.dispose();
  }

  void _solver(BuildContext context, int res) {
    PocketRouter().pop(context);
    if (res == 0) {
      Share.share("""Ti ho invitato al tavolo:
   ${TableBloc.of().value.title}
Per poter ordinare scarica 'Già a Tavola'
      
https://play.google.com/store/apps
      
https://www.apple.com/it/ios/app-store/
""");
      return;
    }
    _inviterBloc.scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Utente aggiunto al tavolo!"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    final tt = theme.textTheme;

    return Form(
      key: _inviterBloc.emailFormKey,
      child: AlertDialog(
        title: Text("Invia invito"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            EmailField(
              checker: _inviterBloc.emailChecker,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("oppure", style: tt.body1.copyWith(color: Colors.grey),),
            ),
            FutureCallBack.raisedButton(
              onPressed: () async {
                final contact = await ContactPicker().selectContact();
                if (contact == null) return;
                final res = await _inviterBloc.inPhoneNumber(int.parse(contact.phoneNumber.number));
                _solver(context, res);
              },
              color: cls.secondaryVariant,
              child: Text("Numero di Telefono"),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => PocketRouter().pop(context),
            child: Text("Anulla"),
          ),
          SubmitButton.flat(
            controller: _inviterBloc.emailSubmitController,
            child: Text("Invita"),
          ),
        ],
      ),
    );
  }
}

/*final permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
              final result = permissions[PermissionGroup.contacts];
              if (result == PermissionStatus.granted) {
                final contacts = await ContactsService.getContacts();
                print("contacts");
              }*/