import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> updateProfileMetrics({
    required String uId,
    required Map<String, dynamic> updatedData,
  });

  Future<UserModel> getCurrentUser(String uId);

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    return getCurrentUser(credential.user!.uid);
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final UserModel userModel = UserModel(
      uId: credential.user!.uid,
      email: email.trim(),
      name: name.trim(),
    );

    await firestore
        .collection('users')
        .doc(credential.user!.uid)
        .set(userModel.toJson());

    return userModel;
  }

  @override
  Future<UserModel> updateProfileMetrics({
    required String uId,
    required Map<String, dynamic> updatedData,
  }) async {
    await firestore.collection('users').doc(uId).update(updatedData);
    return getCurrentUser(uId);
  }

  @override
  Future<UserModel> getCurrentUser(String uId) async {
    final DocumentSnapshot doc =
        await firestore.collection('users').doc(uId).get();

    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }

    final currentUser = firebaseAuth.currentUser;
    return UserModel(
      uId: uId,
      email: currentUser?.email ?? '',
      name: currentUser?.displayName ?? '',
    );
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}