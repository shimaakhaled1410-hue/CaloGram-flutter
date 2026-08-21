import 'package:calogram_flutter/features/data/datasources/auth_remote_data_source.dart';
import 'package:calogram_flutter/features/data/repo_impl/auth_repo_impl.dart';
import 'package:calogram_flutter/features/domain/repo/auth_repo.dart';
import 'package:calogram_flutter/features/domain/usecases/login_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/logout_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/register_usecase.dart';
import 'package:calogram_flutter/features/domain/usecases/update_profile_metrics_usecase.dart';
import 'package:calogram_flutter/features/presentation/manager/auth/auth_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
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
  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(sl<AuthRepo>()),
  );
  sl.registerLazySingleton<RegisterUsecase>(
    () => RegisterUsecase(sl<AuthRepo>()),
  );
  sl.registerLazySingleton<UpdateProfileMetricsUsecase>(
    () => UpdateProfileMetricsUsecase(sl<AuthRepo>()),
  );
  sl.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(sl<AuthRepo>()),
  );

  // Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(
      loginUsecase: sl<LoginUsecase>(),
      registerUsecase: sl<RegisterUsecase>(),
      updateProfileMetricsUsecase: sl<UpdateProfileMetricsUsecase>(),
      logoutUsecase: sl<LogoutUsecase>(),
    ),
  );
}