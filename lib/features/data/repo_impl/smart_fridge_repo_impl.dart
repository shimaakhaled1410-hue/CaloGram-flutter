import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/recipe_entity.dart';
import '../../domain/repo/smart_fridge_repo.dart';
import '../datasources/smart_fridge_remote_data_source.dart';

class SmartFridgeRepoImpl implements SmartFridgeRepo {
  final SmartFridgeRemoteDataSource remoteDataSource;

  const SmartFridgeRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<RecipeEntity>>> generateRecipes(
    List<String> ingredients,
  ) async {
    try {
      final recipes = await remoteDataSource.generateRecipes(ingredients);
      return Right(recipes);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error generating recipes'));
    }
  }
}
