import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


const SPACE = 16.0;


class Paragraph extends StatelessWidget {
  final Widget title, body;

  Paragraph({Key key, @required this.title, @required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DefaultTextStyle(
          style: theme.textTheme.title,
          child: title,
        ),
        Padding(
          padding: const EdgeInsets.all(SPACE),
          child: body,
        ),
      ],
    );
  }
}


class ColorTitle extends StatelessWidget {
  final Color color;
  final Widget child;
  final Widget icon;

  const ColorTitle({Key key, this.color, @required this.child, this.icon,}) :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget body = icon == null ? child : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        child,
        IconTheme(
          data: theme.iconTheme.copyWith(color: Colors.white),
          child: icon,
        ),
      ],
    );

    return Container(
      color: color??theme.buttonColor,
      height: 32.0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DefaultTextStyle(
        style: theme.textTheme.subtitle.copyWith(color: Colors.white),
        child: body,
      ),
    );
  }
}


class Horizontal extends StatelessWidget {
  final Widget left, right, center;

  const Horizontal({Key key, this.left, this.right, this.center}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: left??const SizedBox(),
          ),
          if (center != null)
            center,
          Expanded(
            child: right??const SizedBox(),
          ),
        ],
      ),
    );
  }
}



