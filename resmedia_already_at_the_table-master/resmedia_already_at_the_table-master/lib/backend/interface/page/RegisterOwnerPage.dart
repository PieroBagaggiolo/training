// TODO: DELETE
// import 'package:easy_widget/easy_widget.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:resmedia_already_at_the_table/backend/interface/screen/RegisterOwnerScreen.dart';
//import 'package:resmedia_already_at_the_table/backend/interface/view/InputParagraph.dart';
//import 'package:resmedia_already_at_the_table/interface/view/simply.dart';
//
//
//class RegisterPageOwner extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return RegisterViewPageOwner();
//  }
//}
//
//
//class RegisterViewPageOwner extends StatefulWidget {
//  @override
//  _RegisterViewPageOwnerState createState() => _RegisterViewPageOwnerState();
//}
//
//class _RegisterViewPageOwnerState extends State<RegisterViewPageOwner> {
//  TextEditingController ownerControl, addressControl, vatNumControl, mailControl, passwordControl;
//
//
//  @override
//  void didChangeDependencies() {
////    ownerControl = TextEditingController(text: Sm().ownerName);
////    addressControl = TextEditingController(text: Sm().ownerAddress);
////    vatNumControl = TextEditingController(text: Sm().ownerVatNum);
////    mailControl = TextEditingController(text: Sm().ownerMail);
////    passwordControl = TextEditingController(text: Sm().ownerPassword);
//    super.didChangeDependencies();
//  }
//
////  void _disposeControllers() {
////    ownerControl?.dispose();
////    addressControl?.dispose();
////    vatNumControl?.dispose();
////    mailControl?.dispose();
////    passwordControl?.dispose();
////  }
//
//  @override
//  Widget build(BuildContext context) {
//    return RegisterVoidPageOwner(
////      mailField: EmailFieldShell(
////        bone: _signUpBloc.loginFormBone.emailFieldBone,
////      ),
////      ownerField: TextField(
////        controller: ownerControl,
////        keyboardType: TextInputType.text,
////        decoration: const InputDecoration(
////          suffixIcon: const Icon(Icons.account_circle),
////          border: const OutlineInputBorder(
////            borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
////          ),
////        ),
////      ),
////      addressField: TextField(
////        controller: addressControl,
////        keyboardType: TextInputType.text,
////        decoration: const InputDecoration(
////          suffixIcon: const Icon(Icons.streetview),
////          border: const OutlineInputBorder(
////            borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
////          ),
////        ),
////      ),
////      vatNumField: TextField(
////        controller: vatNumControl,
////        keyboardType: TextInputType.phone,
////        decoration: const InputDecoration(
////          suffixIcon: const Icon(Icons.title),
////          border: const OutlineInputBorder(
////            borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
////          ),
////        ),
////      ),
////      mailField: TextField(
////        controller: mailControl,
////        keyboardType: TextInputType.text,
////        decoration: const InputDecoration(
////          suffixIcon: const Icon(Icons.mail_outline),
////          border: const OutlineInputBorder(
////            borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
////          ),
////        ),
////      ),
////      passwordField: TextField(
////        controller: passwordControl,
////        obscureText: true,
////        keyboardType: TextInputType.text,
////        decoration: const InputDecoration(
////          suffixIcon: const Icon(Icons.lock_outline),
////          border: const OutlineInputBorder(
////            borderRadius: const BorderRadius.all(const Radius.circular(10.0),),
////          ),
////        ),
////      ),
//    );
//  }
//}
//
//
//
//class RegisterVoidPageOwner extends StatelessWidget {
//  final Widget ownerField, addressField, vatNumField, mailField, passwordField;
//
//  const RegisterVoidPageOwner({Key key,
//    @required this.ownerField, @required this.addressField,
//    @required this.vatNumField,
//    @required this.mailField, @required this.passwordField,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return ListViewSeparated(
//      padding: const EdgeInsets.all(SPACE),
//      separator: const SizedBox(height: 16.0,),
//      children: [
//        InputParagraph(
//          title: Text("Proprietario"),
//          child: ownerField,
//        ),
//        InputParagraph(
//          title: Text("Via e Località"),
//          child: addressField,
//        ),
//        InputParagraph(
//          title: Text("Partita Iva"),
//          child: vatNumField,
//        ),
//        InputParagraph(
//          title: Text("Mail"),
//          child: mailField,
//        ),
//        InputParagraph(
//          title: Text("Password"),
//          child: passwordField,
//        ),
//        NavigationButtonsOwner(),
//      ],
//    );
//  }
//}
