import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g6_assessment/core/platform/network_info.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:g6_assessment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:g6_assessment/features/auth/domain/repositories/auth_repository.dart';
import 'package:g6_assessment/features/auth/domain/usecases/login_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/logout_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/signup_usecase.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External packages
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<InternetConnection>(() => InternetConnection());
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(),
  );
  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // data sources
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storage: getIt()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: getIt(), localDataSource: getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );

  // use cases
  getIt.registerLazySingleton(() => LoginUsecase(getIt()));
  getIt.registerLazySingleton(() => LogoutUsecase(getIt()));
  getIt.registerLazySingleton(() => SignUpUsecase(getIt()));

  // Bloc
  getIt.registerFactory(
    () => AuthBloc(
      loginUsecase: getIt(),
      logoutUsecase: getIt(),
      signUpUsecase: getIt(),
    ),
  );
}
