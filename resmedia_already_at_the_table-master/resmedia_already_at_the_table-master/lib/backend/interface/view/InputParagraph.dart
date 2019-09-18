import 'package:flutter/material.dart';

class InputParagraph extends StatelessWidget {
  final EdgeInsets padding;
  final Widget title, child;

  const InputParagraph({Key key,
    this.padding,
    @required this.title, @required this.child
  }) : assert(title != null), assert(child != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DefaultTextStyle(
          style: Theme.of(context).textTheme.title,
          child: title,
        ),
        this.child,
      ],
    );

    return padding == null ? child : Padding(
      padding: padding,
      child: child,
    );
  }
}
