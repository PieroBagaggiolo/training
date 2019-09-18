import 'package:flutter/material.dart';

import 'InputParagraph.dart';


class InputField extends StatelessWidget {
  final Widget title;

  const InputField({Key key, @required this.title}) : assert(title != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputParagraph(
      title: title,
      child: null,
    );
  }
}
