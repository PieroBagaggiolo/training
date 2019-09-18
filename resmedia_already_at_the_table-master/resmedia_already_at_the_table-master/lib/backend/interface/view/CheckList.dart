import 'package:flutter/material.dart';


class CheckItem<T> extends StatelessWidget {
  final bool value;
  final Widget child;

  const CheckItem({Key key,
    this.value: false, @required this.child,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: child,
      leading: Switch(
        value: value,
        onChanged: (_) {},
      ),
    );
  }
}

class CheckList extends StatelessWidget {
  final List<CheckItem> children;

  const CheckList({Key key, @required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
        children: children,
    );
  }
}



