import 'dart:convert';

import 'package:g6_assessment/core/error/exceptions.dart';
import 'package:g6_assessment/features/auth/data/models/user_model.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<User> getUserInfo(String userInfo);

  Future<void> storeUserInfo();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;
  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<User> getUserInfo(String userInfo) async {
    try {
      final data = prefs.getString(userInfo);
      if (data == null) {
        throw CacheException();
      }
      Map<String, dynamic> userData = jsonDecode(data);

      return UserModel.fromJson(userData);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> storeUserInfo() {
    // TODO: implement storeUserInfo
    throw UnimplementedError();
  }
}
