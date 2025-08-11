import 'dart:io' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g6_assessment/core/constants/constants.dart';
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
import 'package:socket_io_client/socket_io_client.dart' as IO;

final getIt = GetIt.instance;

Future<void> init() async {
  // External packages
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<InternetConnection>(() => InternetConnection());
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Setup socket.io client without token initially
  final socket = IO.io(
    ChatApiConstants.forSocket,
    IO.OptionBuilder().setTransports(['websocket']).enableForceNew().build(),
  );
  getIt.registerSingleton<IO.Socket>(socket);

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()));

  // Data sources
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

  // Use cases
  getIt.registerLazySingleton(() => LoginUsecase(getIt()));
  getIt.registerLazySingleton(() => LogoutUsecase(getIt()));
  getIt.registerLazySingleton(() => SignUpUsecase(getIt()));
  getIt.registerLazySingleton(() => LoginWithTokenUsecase(getIt()));

  // Auth BLoC
  getIt.registerFactory(
    () => AuthBloc(
      loginUsecase: getIt(),
      logoutUsecase: getIt(),
      signUpUsecase: getIt(),
      loginWithTokenUsecase: getIt(),
    ),
  );

  // Chat data source
  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(getIt(), getIt()),
  );

  // Chat repository
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt(), getIt(), getIt()),
  );

  // Chat use cases
  getIt.registerLazySingleton(() => MyChatByIdUsecase(getIt()));
  getIt.registerLazySingleton(() => MyChatsUsecase(getIt()));
  getIt.registerLazySingleton(() => DeleteChatUsecase(getIt()));
  getIt.registerLazySingleton(() => GetMessagesUsecase(getIt()));
  getIt.registerLazySingleton(() => InitiateChatUsecase(getIt()));
  getIt.registerLazySingleton(() => GetAllUsersUsecase(getIt()));

  // Chat BLoC
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
