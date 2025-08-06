import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g6_assessment/core/error/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<String?> getAccessToken(String userInfo);
  Future<void> storeAccessToken(String key, String accessToken);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<String?> getAccessToken(String key) async {
    try {
      final data = await storage.read(key: key);
      return data;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> storeAccessToken(String key, String accessToken) async {
    try {
      await storage.write(key: key, value: accessToken);
    } catch (e) {
      throw CacheException();
    }
  }
}
