import 'dart:convert';
import 'package:g6_assessment/core/constants/constants.dart';
import 'package:g6_assessment/core/error/exceptions.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:g6_assessment/features/auth/data/models/user_model.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<User> signUp(String name, String email, String password);
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User> loginWithToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final AuthLocalDataSource localDataSource;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.localDataSource,
  });

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse(AuthApiConstants.loginUrl),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final newAccessToken = data['data']['access_token'];

      await localDataSource.storeAccessToken(
        StorageKeys.accessToken,
        newAccessToken,
      );

      return UserModel.fromJson(data['data']);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.storeAccessToken(StorageKeys.accessToken, '');
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<User> signUp(String name, String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse(AuthApiConstants.registerUrl),
        body: {'email': email, 'password': password, 'name': name},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
      final userData = jsonDecode(response.body)['data'];
      return UserModel.fromJson(userData);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<User> loginWithToken() async {
    final token = await localDataSource.getAccessToken(StorageKeys.accessToken);

    if (token == null || token.isEmpty) {
      throw ServerException();
    }

    final response = await client.get(
      Uri.parse(AuthApiConstants.userMeUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException();
    }

    final userData = jsonDecode(response.body)['data'];
    return UserModel.fromJson(userData);
  }
}
