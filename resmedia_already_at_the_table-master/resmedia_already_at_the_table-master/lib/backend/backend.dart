import 'package:flutter/material.dart';

@protected
class EditScreen extends StatelessWidget {
  final String title;
  final VoidCallback onSave;
  final Widget child;

  const EditScreen({Key key, this.title, @required this.onSave, @required this.child, }) : super(key: key);

  void _onCancel(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: title == null ? null : Text(title),
        actions: <Widget>[
          IconButton(
            onPressed: () => _onCancel(context),
            icon: Icon(Icons.cancel),
          ),
          SizedBox(width: 8,),
          IconButton(
            onPressed: onSave,
            icon: Icon(Icons.done),
          ),
          SizedBox(width: 8,),
        ],
      ),
      body: child,
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton(
                onPressed: () => _onCancel(context),
                color: theme.accentColor,
                child: Text("Annulla"),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: RaisedButton(
                onPressed: onSave,
                color: theme.accentColor,
                child: Text("Salva"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}