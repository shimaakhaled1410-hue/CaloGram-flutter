import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/scanned_food_entity.dart';
import '../../domain/repo/food_scanner_repo.dart';
import '../datasources/food_scanner_remote_data_source.dart';

class FoodScannerRepoImpl implements FoodScannerRepo {
  final FoodScannerRemoteDataSource remoteDataSource;

  FoodScannerRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ScannedFoodEntity>> analyzeFoodImage(
    XFile imageFile,
  ) async {
    try {
      final result = await remoteDataSource.analyzeFoodImage(imageFile);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error during food scanning'));
    }
  }
}
