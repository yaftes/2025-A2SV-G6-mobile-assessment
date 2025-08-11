import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g6_assessment/core/platform/network_info.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:g6_assessment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:g6_assessment/features/auth/domain/repositories/auth_repository.dart';
import 'package:g6_assessment/features/auth/domain/usecases/login_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/login_with_token_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/logout_usecase.dart';
import 'package:g6_assessment/features/auth/domain/usecases/signup_usecase.dart';
import 'package:g6_assessment/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:g6_assessment/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:g6_assessment/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';
import 'package:g6_assessment/features/chat/domain/usecases/delete_chat_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/get_all_users_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/initiate_chat_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/my_chat_by_id_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/my_chats_usecase.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_bloc.dart';
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
  getIt.registerLazySingleton(() => LoginWithTokenUsecase(getIt()));

  // register auth bloc
  getIt.registerFactory(
    () => AuthBloc(
      loginUsecase: getIt(),
      logoutUsecase: getIt(),
      signUpUsecase: getIt(),
      loginWithTokenUsecase: getIt(),
    ),
  );

  // register remote data source
  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(getIt(), getIt()),
  );

  // register the repository
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt(), getIt()),
  );

  // register chat usecases
  getIt.registerLazySingleton(() => MyChatByIdUsecase(getIt()));
  getIt.registerLazySingleton(() => MyChatsUsecase(getIt()));
  getIt.registerLazySingleton(() => DeleteChatUsecase(getIt()));
  getIt.registerLazySingleton(() => GetMessagesUsecase(getIt()));
  getIt.registerLazySingleton(() => InitiateChatUsecase(getIt()));
  getIt.registerLazySingleton(() => GetAllUsersUsecase(getIt()));

  // register chat bloc
  getIt.registerFactory(
    () => ChatBloc(
      deleteChatUsecase: getIt(),
      getMessagesUsecase: getIt(),
      initiateChatUsecase: getIt(),
      myChatByIdUsecase: getIt(),
      myChatsUsecase: getIt(),
      getAllUsersUsecase: getIt(),
    ),
  );
}
