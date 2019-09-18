import 'dart:ui';

import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestStepperButton extends StatefulWidget {
  @override
  _TestStepperButtonState createState() => _TestStepperButtonState();
}

class _TestStepperButtonState extends State<TestStepperButton> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return StepperButton(
      child: Text('$_value'),
      onDecrease: () => setState(() => _value - 1),
      onIncrement: () => setState(() => _value + 1),
    );
  }
}



class HiddenStepperButton extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement, onDecrease;

  HiddenStepperButton({Key key, this.value, this.onIncrement, this.onDecrease}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget body;
    final theme = Theme.of(context);
    if (value == 0) {
      body = RaisedButton(
        onPressed: onIncrement,
        color: theme.primaryColor,
        child: Text(
          "ADD",
          style: theme.textTheme.button,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      );
    } else {
      body = StepperButton(
        child: Text('$value'),
        onDecrease: onDecrease,
        onIncrement: onIncrement,
      );
    }
    return body;
  }
}
