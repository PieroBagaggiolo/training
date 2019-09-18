import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_already_at_the_table/generated/i18n.dart';
import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
import 'package:resmedia_already_at_the_table/r.dart';

class SignWidget extends StatefulWidget {
  final List<Widget> fields;
  final Widget topButton, bottomButton;

  SignWidget({
    Key key,
    @required this.fields,
    @required this.topButton,
    @required this.bottomButton,
  }) : super(key: key);

  @override
  _SignWidgetState createState() => _SignWidgetState();
}

class _SignWidgetState extends State<SignWidget> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    //final tt = theme.textTheme;
    final cls = theme.colorScheme;

    return SignBackground(
      children: <Widget>[
        Wrap(
          runSpacing: 12,
          children: widget.fields,
        ),
        /*Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Remember Me', style: tt.caption,),
            RememberMeField(
              controller: rememberMeController,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),*/
        Divider(
          height: 0,
        ),
        Row(
          children: <Widget>[
            Text(
              s.orWith,
              style: theme.textTheme.caption,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.google,
                      color: theme.primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.twitter,
                      color: theme.primaryColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.facebook,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        ButtonTheme.fromButtonThemeData(
          data: theme.buttonTheme.copyWith(
            buttonColor: cls.secondaryVariant,
          ),
          child: widget.topButton,
        ),
        if (widget.bottomButton != null) widget.bottomButton,
      ],
    );
  }
}

class SignBackground extends StatelessWidget {
  final bool automaticallyImplyLeading;
  final Widget separator;
  final List<Widget> children;

  SignBackground({
    Key key,
    this.automaticallyImplyLeading: true,
    @required this.children,
    this.separator: const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(R.assetsImgBackground),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: automaticallyImplyLeading,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
//            StreamBuilder<SocialClass>(
//              initialData: SocialClass.user,
//              stream: _userBloc.outSocialClass,
//              builder: (context, snapshot) {
//                final socialClass = snapshot.data;
//
//                return IconButton(
//                  onPressed: () => _userBloc.inSocialClass(
//                      socialClass == SocialClass.user
//                          ? SocialClass.restaurateur
//                          : SocialClass.user),
//                  icon: socialClass == SocialClass.user
//                      ? const Icon(Icons.account_circle)
//                      : const Icon(Icons.restaurant_menu),
//                );
//              },
//            ),
            TranslationButton(),
          ],
        ),
        endDrawer: TranslationDrawer(locales: S.delegate.supportedLocales),
        body: ListViewSeparated(
          separator: separator,
          padding: const EdgeInsets.symmetric(horizontal: SPACE * 2, vertical: SPACE),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset(R.assetsImgLogo),
            ),
            const SizedBox(
              height: 16,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
