import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:g6_assessment/core/platform/network_info.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:g6_assessment/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

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

  test('test the repository works as expected', () {});
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