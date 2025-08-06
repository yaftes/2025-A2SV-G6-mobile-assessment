import 'dart:convert';
import 'package:g6_assessment/core/error/exceptions.dart';
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

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<User> login(String email, String password) async {
    final url = Uri.https(
      'g5-flutter-learning-path-be.onrender.com/api/v3/auth/login',
      '/api/v3/auth/login',
    );

    final url1 = Uri.https(
      'g5-flutter-learning-path-be.onrender.com/api/v3/auth/login',
      '/api/v2/users/me',
    );

    try {
      final response = await client.post(
        url,
        body: {'email': email, 'password': password},
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException();
      } else {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final accessToken = data['data']['access_token'];

        final userData = await client.get(
          url1,
          headers: {"Authorization": accessToken},
        );

        // TODO: handle the response from the api

        return UserModel();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> logout() async {}

  @override
  Future<User> signUp(String name, String email, String password) async {
    final url = Uri.https(
      'g5-flutter-learning-path-be.onrender.com/api/v3/auth/login',
      '/api/v3/auth/register',
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
