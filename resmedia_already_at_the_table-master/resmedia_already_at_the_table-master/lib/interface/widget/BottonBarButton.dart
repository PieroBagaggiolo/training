import 'package:flutter/material.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';

class BottomBarButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final Widget child;

  const BottomBarButton({
    Key key,
    this.color,
    this.onPressed,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    final tt = theme.textTheme;

    return RaisedButton(
      color: color ?? cls.secondaryVariant,
      shape: Border(),
      onPressed: onPressed,
      child: DefaultTextStyle(
        style: tt.button.copyWith(fontSize: RepositoryBloc.of().sp.get(50)),
        child: child,
      ),
    );
  }
}
