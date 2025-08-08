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

      print('response from server ${response.body}');

      if (response.statusCode >= 400 && response.statusCode < 500) {
        throw UnauthorizedException('Invalid email or password');
      }

      if (response.statusCode >= 500) {
        throw ServerException('Server error, please try again later');
      }

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      if (decoded['data'] == null || decoded['data']['access_token'] == null) {
        throw ServerException('Access token not found in response');
      }

      final newAccessToken = decoded['data']['access_token'];

      await localDataSource.storeAccessToken(
        StorageKeys.accessToken,
        newAccessToken,
      );

      return await loginWithToken();
    } on UnauthorizedException {
      rethrow;
    } on FormatException {
      throw ServerException('Invalid JSON format from server');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<User> loginWithToken() async {
    final token = await localDataSource.getAccessToken(StorageKeys.accessToken);

    if (token == null || token.isEmpty) {
      throw CacheException('please login again your access token is expired');
    }

    final response = await client.get(
      Uri.parse(AuthApiConstants.userMeUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode >= 400 && response.statusCode < 500) {
      await localDataSource.deleteAccessToken(token);
      throw ServerException('Unauthorized, please register first');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw ServerException(response.body);
    }

    try {
      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final data = decoded['data'];

      if (data == null && response.statusCode == 200) {
        // we assue here the status code
        // await localDataSource.deleteAccessToken(StorageKeys.accessToken);
        return User();
      }

      return User(id: data['_id'], name: data['name'], email: data['email']);
    } on FormatException catch (_) {
      throw ServerException('Invalid JSON from server');
    } catch (e) {
      throw ServerException(e.toString());
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

      if (response.statusCode == 409) {
        throw ServerException('User already exists, please try to login');
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Server failure');
      }

      final userData = jsonDecode(response.body)['data'];
      return UserModel.fromJson(userData);
    } on ServerException {
      rethrow;
    } on FormatException {
      throw ServerException('Invalid JSON from server');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
