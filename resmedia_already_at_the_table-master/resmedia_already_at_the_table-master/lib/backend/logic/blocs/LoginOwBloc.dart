//import 'package:easy_blocs/easy_blocs.dart';
//import 'package:flutter/cupertino.dart';
//
//
//class LoginOwBloc extends BlocBase {
//  final _pocket = Pocket();
//
//  @override
//  void dispose() {
//    super.dispose();
//  }
//
//  final SignInSkeleton _loginFormSkeleton = SignInSkeleton();
//  SignInSkeleton get loginFormBone => _loginFormSkeleton;
//
//  LoginOwBloc({@required UserBoneBase userBone}) {
//    _loginFormSkeleton.userBone = userBone;
//  }
//  static void init(LoginOwBloc bloc) => BlocProvider.init(bloc);
//  factory LoginOwBloc.of() => BlocProvider.of<LoginOwBloc>();
//  static void close() => BlocProvider.dispose<LoginOwBloc>();
//}