import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> signInAnonymously();
  Future<UserModel> linkAccountWithEmail({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> updateProfileMetrics({
    required String uId,
    required Map<String, dynamic> updatedData,
  });

  Future<UserModel?> getCurrentUser(String uId);

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await firebaseAuth
          .signInWithEmailAndPassword(email: email.trim(), password: password);

      final user = await getCurrentUser(credential.user!.uid);
      if (user != null) {
        return user;
      } else {
        throw ServerException('Failed to fetch user profile');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is AuthException || e is ServerException) rethrow;
      throw ServerException('An unexpected error occurred during login');
    }
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(
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
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed');
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException('An unexpected error occurred during registration');
    }
  }

  @override
  Future<UserModel> updateProfileMetrics({
    required String uId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      await firestore.collection('users').doc(uId).update(updatedData);
      final user = await getCurrentUser(uId);
      if (user != null) {
        return user;
      } else {
        throw ServerException('Failed to fetch updated profile');
      }
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to update metrics');
    }
  }

  @override
  Future<UserModel?> getCurrentUser(String uId) async {
    try {
      final DocumentSnapshot doc = await firestore
          .collection('users')
          .doc(uId)
          .get();

      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }

      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null) {
        return UserModel(
          uId: uId,
          email: currentUser.email ?? '',
          name: currentUser.displayName ?? '',
        );
      }
      return null;
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw ServerException('Failed to retrieve user');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw ServerException('Failed to sign out');
    }
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      final UserCredential credential = await firebaseAuth.signInAnonymously();
      final uId = credential.user!.uid;

      final UserModel guestUser = UserModel(
        uId: uId,
        email: '',
        name: 'Guest User',
      );

      await firestore
          .collection('users')
          .doc(uId)
          .set(guestUser.toJson(), SetOptions(merge: true));
      return guestUser;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Anonymous login failed');
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw ServerException('Failed to continue as guest');
    }
  }

  @override
  Future<UserModel> linkAccountWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw AuthException('No active guest session found');
      }

      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );

      final userCredential = await currentUser.linkWithCredential(credential);
      final user = userCredential.user ?? currentUser;

      await user.updateDisplayName(name.trim());

      final updatedModel = UserModel(
        uId: user.uid,
        email: email.trim(),
        name: name.trim(),
      );

      await firestore.collection('users').doc(user.uid).set({
        'name': name.trim(),
        'email': email.trim(),
      }, SetOptions(merge: true));

      return updatedModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Failed to link account');
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is AuthException) rethrow;
      throw ServerException('Unexpected error during account upgrade');
    }
  }
}
