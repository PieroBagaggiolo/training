import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoder/geocoder.dart';
import 'package:pocket_map/pocket_map.dart';

import 'package:resmedia_already_at_the_table/logic/bloc/UserBloc.dart';
import 'package:resmedia_already_at_the_table/logic/fs/User.dart';
import 'package:resmedia_already_at_the_table/logic/repository/RepositoryBloc.dart';
import 'package:resmedia_already_at_the_table/logic/repository/SignRepository.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc extends BlocBase with SingInBlocMixer {
  final FormBone formBone = FormSkeleton();

  @override
  void dispose() {
    _signInSkeleton.dispose();
    _eventController.close();
    super.dispose();
  }

  final SignInSkeleton<AuthResult> _signInSkeleton;
  @override
  SignInBone get signInBone => _signInSkeleton;

  final PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

  set onResult(AsyncValueSetter<AuthResult> onResult) => _signInSkeleton.onResult = onResult;

  SignInBloc({
    @required SignRepository signRepository,
  }) : this._signInSkeleton = SignInSkeleton(signBone: signRepository);
  factory SignInBloc.init(SignInBloc bloc) => BlocProvider.init(bloc);
  factory SignInBloc.of([allowNull = false]) => BlocProvider.of<SignInBloc>(allowNull);
  static void close() => BlocProvider.dispose<SignInBloc>();
}

class SignUpBloc extends BlocBase with SingUpBlocMixer {
  final FormBone formBone = FormSkeleton();

  void dispose() {
    _signUpSkeleton.dispose();
    _eventController.close();
    super.dispose();
  }

  final SignUpSkeleton<AuthResult> _signUpSkeleton;
  @override
  SignUpBone get signUpBone => _signUpSkeleton;

  final PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

  set onResult(AsyncValueSetter<AuthResult> onResult) => _signUpSkeleton.onResult = onResult;

  SignUpBloc({
    @required SignRepository signRepository,
  }) : this._signUpSkeleton = SignUpSkeleton(signBone: signRepository);
  factory SignUpBloc.init(SignUpBloc bloc) => BlocProvider.init(bloc);
  factory SignUpBloc.of([allowNull = false]) => BlocProvider.of<SignUpBloc>(allowNull);
  static void close() => BlocProvider.dispose<SignUpBloc>();
}

class SignUpMoreBloc implements BlocBase {
  final UserBloc _userBloc = UserBloc.of();

  @override
  void dispose() {
    _placeFieldSkeleton.dispose();
    _nominativeFieldSkeleton.dispose();
    _phoneNumberFieldSkeleton.dispose();
    _buttonFieldSkeleton.dispose();
  }

  final FormBone formBone = FormSkeleton();

  final PlaceFieldSkeleton _placeFieldSkeleton = PlaceFieldSkeleton(
    apiKey: RepositoryBloc.of().googleMapsApiKey,
  );
  PlaceFieldBone get placeFieldBone => _placeFieldSkeleton;

  final NominativeFieldSkeleton _nominativeFieldSkeleton = NominativeFieldSkeleton();
  NominativeFieldBone get nominativeFieldBone => _nominativeFieldSkeleton;

  final TextFieldAdapter<int> _phoneNumberFieldSkeleton = TextFieldAdapter.phoneNumber();
  TextFieldBone get phoneNumberFieldBone => _phoneNumberFieldSkeleton;

  final ButtonFieldSkeleton _buttonFieldSkeleton = ButtonFieldSkeleton();
  ButtonFieldBone get buttonFieldBone => _buttonFieldSkeleton;

  final PublishSubject _eventController = PublishSubject();
  Stream get outEvent => _eventController;

  SignUpMoreBloc() {
    _userBloc.userBone.outUser.listen((user) {
      if (user == null) return;

      _placeFieldSkeleton.inValue(user.address?.addressLine);
      _nominativeFieldSkeleton.inValue(user.nominative);
      _phoneNumberFieldSkeleton.inAdapterValue(user.phoneNumber);
    });

    _buttonFieldSkeleton.onSubmit = () async {
      final address =
          (await Geocoder.local.findAddressesFromQuery(_placeFieldSkeleton.value)).first;
      if (address == null) return ButtonState.working;

      final userBloc = UserBloc.of();
      final user = userBloc.userBone.user;
      await UserCl().doc(user.id).updateModel(UserModel(
            nominative: _nominativeFieldSkeleton.value,
            phoneNumber: _phoneNumberFieldSkeleton.adapterValue,
            address: address,
          ));

      _eventController.add(CompletedEvent([await _userBloc.getUserByRegistrationLv(1)]));
      return ButtonState.disabled;
    };
  }
  factory SignUpMoreBloc.init(SignUpMoreBloc bloc) => BlocProvider.init(bloc);
  factory SignUpMoreBloc.of() => BlocProvider.of<SignUpMoreBloc>();
  static void close() => BlocProvider.dispose<SignUpMoreBloc>();
}
