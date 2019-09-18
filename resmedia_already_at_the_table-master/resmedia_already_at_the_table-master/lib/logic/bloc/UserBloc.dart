import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Functions.dart';
import 'package:resmedia_already_at_the_table/logic/fs/Stripe.dart';
import 'package:resmedia_already_at_the_table/logic/fs/User.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';
import 'package:resmedia_already_at_the_table/model/stripe/SourceStripeModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_stripe/easy_stripe.dart';

class UserBloc extends BlocBase with UserBlocMixin<UserModel>, FbUserBlocMixin {
  final RepositoryBloc _repositoryBloc = RepositoryBloc.of();

  Uri deepLink;
  final Pocket _pocket = Pocket();

  @protected
  dispose() {
    _userSkeleton.dispose();
    _stripeController.close();
    super.dispose();
  }

  final FbUserSkeleton<UserModel> _userSkeleton;
  FbUserBone<UserModel> get userBone => _userSkeleton;

  final DefaultStripeController<SourceStripeModel> _stripeController =
      DefaultStripeController<SourceStripeModel>(publishableKey: STRIPE_PUBLIC_KEY);
  StripeManager get stripeManager => _stripeController;

  bool _isActiveLocation = false;
  BehaviorSubject<GeoFirePoint> _pointController = BehaviorSubject();
  Stream<GeoFirePoint> get outPoint => _pointController;

  UserBloc({
    @required FirebaseUser firebaseUser,
  }) : this._userSkeleton = FbUserSkeleton(outUser: UserCl().firebaseUser(firebaseUser).outer()) {
    _userSkeleton.outUser.listen((user) {
      if (_isActiveLocation || user?.address == null) return;
      final coordinates = user.address.coordinates;
      _pointController.add(GeoFirePoint(coordinates.latitude, coordinates.longitude));
    });
    _pocket.putAndGet(_pointController).catchSource(
          source: () => _repositoryBloc.outLocation,
          onData: (location) {
            if (location == null) return;
            _isActiveLocation = true;
            _pointController.add(GeoFirePoint(location.latitude, location.longitude));
          },
        );
    _stripeController.outSources = _userSkeleton.outUser.distinct((bef, aft) {
      return bef?.id == aft?.id;
    }).asyncExpand((user) {
      if (user == null) return null;
      _stripeController.adderSource =
          (data) => FbCloudFunctions().addStripeSource(user.id, data.toJson());
      return SourceStripeCl(user.id).outer();
    });
  }
  factory UserBloc.init(UserBloc bloc) => BlocProvider.init<UserBloc>(bloc);
  factory UserBloc.of() => BlocProvider.of<UserBloc>();
  static void close() => BlocProvider.dispose<UserBloc>();
}

//class _UserEvent {
//  final SocialClass socialClass;
//  final int registrationLv;
//
//  _UserEvent(this.socialClass, this.registrationLv);
//}

//class DorBloc extends BlocBase {
//  final _pocket = Pocket();
//
//  @override
//  void dispose() {
//    _dorSkeleton.dispose();
//    _socialClassController.close();
//    super.dispose();
//  }
//
//  final DorFbSkeleton _dorSkeleton = DorFbSkeleton(firebaseAuth: FirebaseAuth.instance);
//  DorFbBone get dorBone => _dorSkeleton;
//
//  final PreferenceStorage _preferenceStorage = PreferenceStorage.manager(VersionManager("USER"));
//
//  BehaviorSubject<SocialClass> _socialClassController = BehaviorSubject();
//  Stream<SocialClass> get outSocialClass => _socialClassController;
//
//  Stream<Data2<FirebaseUser, SocialClass>> get outEvent => Observable.combineLatest2(
//      dorBone.outUser, outSocialClass, (firebaseUser, socialClass) {
//    return firebaseUser == null ? null : Data2(firebaseUser, socialClass);
//  });
//
//  DorBloc() {
//    _preferenceStorage.getEnum(enumValues: SocialClass.values).then(_socialClassController.add);
//  }
//  static void init(DorBloc bloc) => BlocProvider.init(bloc);
//  factory DorBloc.of() => BlocProvider.of<DorBloc>();
//  static void close() => BlocProvider.dispose<DorBloc>();
//
//  Future<void> inSocialClass(SocialClass socialClass) async {
//    _socialClassController.add(socialClass);
//  }
//}
//
//
//class UserBloc extends BlocBase {
//  final Pocket _pocket = Pocket();
//
//  @protected
//  dispose() {
//    _userSkeleton.dispose();
//    _stripeController.close();
//    super.dispose();
//  }
//
//  final UserFbSkeleton<UserModel, UserCl> _userSkeleton;
//  UserFbBone<UserModel, UserCl> get userBone => _userSkeleton;
//
//
//  final DefaultStripeController _stripeController = DefaultStripeController(
//      publishableKey: STRIPE_PUBLIC_KEY);
//  StripeManager get stripeManager => _stripeController;
//
//  UserBloc({@required UserDc userDc,
//  }) : this._userSkeleton = UserFbSkeleton(
//    userDc: userDc,
//  ) {
//    final userID = userDc.reference.documentID;
//
//    _stripeController.adderSource = (data) =>
//        FunctionsFb().addStripeSource(userID, data.toJson());
//    _stripeController.outSources = SourceStripeCl(userID).stream;
//  }
//  factory UserBloc.of() => BlocProvider.of<UserBloc>();
//  static void init(UserBloc bloc) => BlocProvider.init(bloc);
//  static void close() => BlocProvider.dispose<UserBloc>();
//}
