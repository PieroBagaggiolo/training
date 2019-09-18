import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/user.dart';
import 'package:easy_firebase/sign.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignRepository extends BlocBase with SignBlocMixin<FirebaseUser, AuthResult>, FbSignBlocMixin {
  //final _pocket = Pocket();

  @override
  void dispose() {
    super.dispose();
  }

  FbSignSkeleton _signSkeleton = FbSignSkeleton();
  @override
  FbSignBone get signBone => _signSkeleton;

  SignRepository();
  factory SignRepository.init(SignRepository bloc) => BlocProvider.init<SignRepository>(bloc);
  factory SignRepository.of([allowNull = false]) => BlocProvider.of<SignRepository>(allowNull);
  static void close() => BlocProvider.dispose<SignRepository>();
}
