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

  // login with access token
}

// if the user have access token send request using that access token
// if not show login page

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

      String? storedAccessToken = (await localDataSource.getAccessToken(
        StorageKeys.accessToken,
      ));

      if (storedAccessToken != null) {
        final responseFromAccessTokenRequest = await client.get(
          Uri.parse(AuthApiConstants.userMeUrl),
          headers: {'Authorization': 'Bearer $storedAccessToken'},
        );

        if (responseFromAccessTokenRequest.statusCode != 200 &&
            responseFromAccessTokenRequest.statusCode != 201) {
          throw ServerException();
        }
        final userData =
            jsonDecode(responseFromAccessTokenRequest.body)['data']
                as Map<String, dynamic>;

        return UserModel.fromJson(userData);
      }

      final response = await client.post(
        Uri.parse(AuthApiConstants.loginUrl),
        body: {'email': email, 'password': password},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      }
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final newAccessToken = data['data']['access_token'];

      final responseFromAccessTokenRequest = await client.get(
        Uri.parse(AuthApiConstants.userMeUrl),
        headers: {'Authorization': 'Bearer $newAccessToken'},
      );

      if (responseFromAccessTokenRequest.statusCode != 200 &&
          responseFromAccessTokenRequest.statusCode != 201) {
        throw ServerException();
      }
      final userData =
          jsonDecode(responseFromAccessTokenRequest.body)['data']
              as Map<String, dynamic>;

      await localDataSource.storeAccessToken(
        StorageKeys.accessToken,
        newAccessToken,
      );

      return UserModel.fromJson(userData);
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localDataSource.storeAccessToken(StorageKeys.accessToken, '');
    } catch (e) {
      CacheException();
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
}
