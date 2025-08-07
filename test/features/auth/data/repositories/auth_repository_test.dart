import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g6_assessment/core/platform/network_info.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:g6_assessment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([
  NetworkInfo,
  AuthLocalDataSource,
  AuthRemoteDataSource,
  http.Client,
  FlutterSecureStorage,
])
void main() {
  late MockClient client;
  late MockFlutterSecureStorage storage;
  late MockAuthLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;
  late AuthRemoteDataSource remoteDataSource;
  late AuthRepositoryImpl repository;

  setUp(() {
    storage = MockFlutterSecureStorage();
    localDataSource = MockAuthLocalDataSource();
    remoteDataSource = MockAuthRemoteDataSource();
    networkInfo = MockNetworkInfo();
    client = MockClient();
    repository = AuthRepositoryImpl(
      networkInfo: networkInfo,
      remoteDataSource: remoteDataSource,
    );
  });

  test('verify the login fails when there is internet connection ', () {
    // network info set it to false
    when(() => networkInfo.isConnected).thenAnswer((invocation) async {
      return false;
    });
    // remote data source for login
    when(() => remoteDataSource.login('email', 'password')).thenAnswer((
      invocation,
    ) async {
      final email = invocation.positionalArguments.first as String;
      final password = invocation.positionalArguments[1] as String;
      return User(email: email, password: password);
    });
  });
  // when the login
}


/*

local data source
   | 
   |
remote data source 
   |
   |
repository




*/