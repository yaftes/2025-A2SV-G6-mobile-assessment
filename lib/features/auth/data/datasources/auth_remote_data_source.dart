import 'dart:convert';
import 'package:g6_assessment/core/error/exceptions.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:g6_assessment/features/auth/data/models/user_model.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<User> signUp(String name, String email, String password);

  Future<User> login(String email, String password);

  Future<void> logout();
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
    // : send first
    // : use the access token then make another request
    // : store the access token
    // : fetch the data and navigate to home page

    final url = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/api/v3/auth/login',
    );

    try {
      final response = await client.post(
        url,
        body: {'email': email, 'password': password},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final accessToken = data['data']['access_token'];

      final urlForAccessToken = Uri.parse(
        'https://g5-flutter-learning-path-be.onrender.com/api/v3/users/me',
      );

      final responseFromAccessTokenRequest = await client.get(
        urlForAccessToken,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (responseFromAccessTokenRequest.statusCode != 200 &&
          responseFromAccessTokenRequest.statusCode != 201) {
        throw ServerException();
      }
      final userData =
          jsonDecode(responseFromAccessTokenRequest.body)['data']
              as Map<String, dynamic>;

      await localDataSource.storeAccessToken('ACCESS_TOKEN', accessToken);

      return UserModel.fromJson(userData);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.storeAccessToken('ACCESS_TOKEN', '');
    } catch (e) {
      CacheException();
    }
  }

  @override
  Future<User> signUp(String name, String email, String password) async {
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/api/v3/auth/register',
    );

    try {
      final response = await client.post(
        url,
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
}
