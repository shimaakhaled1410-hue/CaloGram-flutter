import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/meal_entity.dart';
import 'package:calogram_flutter/features/domain/repo/dashboard_repo.dart';
import 'package:calogram_flutter/features/domain/usecases/dashboard/log_meal_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// 1. Mock Dashboard Repository
class MockDashboardRepo extends Mock implements DashboardRepo {}

void main() {
  late LogMealUsecase usecase;
  late MockDashboardRepo mockDashboardRepo;

  setUp(() {
    mockDashboardRepo = MockDashboardRepo();
    usecase = LogMealUsecase(mockDashboardRepo);
  });

  // Mock Meal Data matching MealEntity schema exactly
  final tMeal = MealEntity(
    id: 'meal_123',
    title: 'Grilled Chicken Salad',
    mealType: 'Lunch',
    calories: 350,
    protein: 40,
    carbs: 12,
    fats: 8,
    loggedAt: DateTime(2026, 8, 24),
  );

  test(
    'should return Right(null) when repository logs meal successfully',
    () async {
      // Arrange
      when(
        () => mockDashboardRepo.logMeal(tMeal),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await usecase(tMeal);

      // Assert
      expect(result, const Right(null));
      verify(() => mockDashboardRepo.logMeal(tMeal)).called(1);
      verifyNoMoreInteractions(mockDashboardRepo);
    },
  );

  test(
    'should return ServerFailure when repository fails to log meal',
    () async {
      // Arrange
      final tFailure = ServerFailure('Database connection error');
      when(
        () => mockDashboardRepo.logMeal(tMeal),
      ).thenAnswer((_) async => Left(tFailure));

      // Act
      final result = await usecase(tMeal);

      // Assert
      expect(result, Left(tFailure));
      verify(() => mockDashboardRepo.logMeal(tMeal)).called(1);
      verifyNoMoreInteractions(mockDashboardRepo);
    },
  );
}
