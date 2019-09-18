import 'package:flutter/widgets.dart';


class ColumnDrawer extends StatelessWidget {
  final Color color;
  final List<Widget> children;

  const ColumnDrawer({Key key, @required this.color, @required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: SafeArea(
        child: Column(
          children: children,
        ),
      ),
    );
  }
}