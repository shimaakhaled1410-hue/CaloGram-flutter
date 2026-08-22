import 'package:calogram_flutter/core/errors/failure.dart';
import 'package:calogram_flutter/features/domain/entities/scanned_food_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/repo/voice_logger_repo.dart';
import '../datasources/voice_logger_remote_data_source.dart';

class VoiceLoggerRepoImpl implements VoiceLoggerRepo {
  final VoiceLoggerRemoteDataSource remoteDataSource;

  VoiceLoggerRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ScannedFoodEntity>> analyzeVoiceLog(
    String transcribedText,
  ) async {
    try {
      final result = await remoteDataSource.analyzeVoiceLog(transcribedText);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return Left(ServerFailure('Unexpected error during voice analysis'));
    }
  }
}
