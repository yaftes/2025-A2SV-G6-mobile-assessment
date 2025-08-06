import 'package:g6_assessment/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({super.name, super.password, super.id, super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      'password': password ?? '',
      'email': email ?? '',
      'id': id ?? '',
    };
  }
}
