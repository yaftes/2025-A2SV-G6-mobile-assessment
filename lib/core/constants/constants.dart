class AuthApiConstants {
  static const String baseUrl =
      'https://g5-flutter-learning-path-be.onrender.com/api/v3';

  static const String loginUrl = '$baseUrl/auth/login';
  static const String registerUrl = '$baseUrl/auth/register';
  static const String userMeUrl = '$baseUrl/users/me';
}

class StorageKeys {
  static const String accessToken = 'ACCESS_TOKEN';
}
