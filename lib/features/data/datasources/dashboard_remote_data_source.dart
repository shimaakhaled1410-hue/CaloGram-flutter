import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/meal_model.dart';
import '../models/user_model.dart';

abstract class DashboardRemoteDataSource {
  Future<UserModel> fetchUserProfile(String uId);
  Future<List<MealModel>> fetchTodayMeals(String uId);
  Future<void> logMeal(String uId, MealModel meal);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  DashboardRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  @override
  Future<UserModel> fetchUserProfile(String uId) async {
    try {
      final doc = await firestore.collection('users').doc(uId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      throw ServerException('User profile not found');
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to load user profile');
    }
  }

  @override
  Future<List<MealModel>> fetchTodayMeals(String uId) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

      final snapshot = await firestore
          .collection('users')
          .doc(uId)
          .collection('meals')
          .where('loggedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('loggedAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      return snapshot.docs
          .map((doc) => MealModel.fromJson(doc.data(), doc.id))
          .toList();
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw ServerException('Failed to fetch today meals');
    }
  }

  @override
  Future<void> logMeal(String uId, MealModel meal) async {
    try {
      await firestore
          .collection('users')
          .doc(uId)
          .collection('meals')
          .add(meal.toJson());
    } on SocketException {
      throw NetworkException('No internet connection');
    } catch (_) {
      throw ServerException('Failed to log meal');
    }
  }
}