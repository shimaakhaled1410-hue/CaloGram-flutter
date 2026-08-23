import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../entities/recipe_entity.dart';

abstract class SmartFridgeRepo {
  Future<Either<Failure, List<RecipeEntity>>> generateRecipes(
    List<String> ingredients,
  );
}
