import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resmedia_already_at_the_table/model/UserModel.dart';

final _fs = Firestore.instance;

const users = 'users';

mixin UserDispenser implements UserDispenserBase<UserModel> {
  @override
  FromJson<UserModel> get fromJson => UserModel.fromJson;
}

class UserCl extends UserClBase<UserModel> with UserDispenser {
  final CollectionReference reference;

  UserCl._(this.reference, Query query) : super(query);

  factory UserCl() {
    final CollectionReference reference = _fs.collection(users);
    return UserCl._(reference, reference);
  }

  UserDc doc([String documentID]) => UserDc(reference.document(documentID));

  @override
  UserDc firebaseUser(FirebaseUser firebaseUser) => UserDc.fs(firebaseUser);
}

class UserDc extends UserDcBase<UserModel> with UserDispenser {
  UserDc(DocumentReference reference) : super(reference);

  UserDc.fs(FirebaseUser firebaseUser)
      : super.fs(
          firebaseUser,
          UserCl().reference,
        );
}
