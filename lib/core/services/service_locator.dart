import 'package:calogram_flutter/features/data/datasources/auth_remote_data_source.dart';
import 'package:calogram_flutter/features/data/datasources/dashboard_remote_data_source.dart';
import 'package:calogram_flutter/features/data/datasources/food_scanner_remote_data_source.dart';
import 'package:calogram_flutter/features/data/datasources/voice_logger_remote_data_source.dart';
import 'package:calogram_flutter/features/data/repo_impl/auth_repo_impl.dart';
import 'package:calogram_flutter/features/data/repo_impl/dashboard_repo_impl.dart';
import 'package:calogram_flutter/features/data/repo_impl/food_scanner_repo_impl.dart';
import 'package:calogram_flutter/features/data/repo_impl/voice_logger_repo_impl.dart';
import 'package:calogram_flutter/features/domain/repo/auth_repo.dart';
import 'package:calogram_flutter/features/domain/repo/dashboard_repo.dart';
import 'package:calogram_flutter/features/domain/repo/food_scanner_repo.dart';
import 'package:calogram_flutter/features/domain/repo/voice_logger_repo.dart';
import 'package:calogram_flutter/features/domain/usecases/auth/login_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/auth/logout_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/auth/register_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/auth/update_profile_metrics_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/dashboard/get_dashboard_data_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/dashboard/log_meal_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/food_scanner/analyze_food_image_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/voice_logger/analyze_voice_log_usecase.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/dashboard/dashboard_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/food_scanner/food_scanner_cubit.dart';
import 'package:calogram_flutter/features/presentation/manager/voice_logger/voice_logger_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  ///auth///

  // External
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  // UseCases
  sl.registerLazySingleton<LoginUsecase>(() => LoginUsecase(sl<AuthRepo>()));
  sl.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(sl<AuthRepo>()),
  );
  sl.registerLazySingleton<UpdateProfileMetricsUsecase>(
    () => UpdateProfileMetricsUsecase(sl<AuthRepo>()),
  );
  sl.registerLazySingleton<LogoutUsecase>(() => LogoutUsecase(sl<AuthRepo>()));

  // Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUsecase: sl<LoginUsecase>(),
      registerUsecase: sl<RegisterUsecase>(),
      updateProfileMetricsUsecase: sl<UpdateProfileMetricsUsecase>(),
      logoutUsecase: sl<LogoutUsecase>(),
    ),
  );

  /// dashboard ///

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(
      firebaseAuth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  sl.registerLazySingleton<DashboardRepo>(
    () => DashboardRepoImpl(remoteDataSource: sl<DashboardRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetDashboardDataUsecase>(
    () => GetDashboardDataUsecase(sl<DashboardRepo>()),
  );
  sl.registerLazySingleton<LogMealUsecase>(
    () => LogMealUsecase(sl<DashboardRepo>()),
  );

  sl.registerFactory<DashboardCubit>(
    () => DashboardCubit(
      getDashboardDataUsecase: sl<GetDashboardDataUsecase>(),
      logMealUsecase: sl<LogMealUsecase>(),
    ),
  );

  /// food scanner ///

  sl.registerLazySingleton<FoodScannerRemoteDataSource>(
    () => FoodScannerRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<FoodScannerRepo>(
    () => FoodScannerRepoImpl(
      remoteDataSource: sl<FoodScannerRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<AnalyzeFoodImageUsecase>(
    () => AnalyzeFoodImageUsecase(sl<FoodScannerRepo>()),
  );

  sl.registerFactory<FoodScannerCubit>(
    () => FoodScannerCubit(
      analyzeFoodImageUsecase: sl<AnalyzeFoodImageUsecase>(),
      logMealUsecase: sl<LogMealUsecase>(),
    ),
  );

  /// voice logger ///
  
  sl.registerLazySingleton<VoiceLoggerRemoteDataSource>(
      () => VoiceLoggerRemoteDataSourceImpl());

  sl.registerLazySingleton<VoiceLoggerRepo>(
      () => VoiceLoggerRepoImpl(remoteDataSource: sl()));

  sl.registerLazySingleton(() => AnalyzeVoiceLogUsecase(sl()));

  sl.registerFactory(() => VoiceLoggerCubit(analyzeVoiceLogUsecase: sl(), logMealUsecase: sl()));
}
