import 'package:g6_assessment/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel(String name, String password)
    : super(name: name, password: password);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(json['name'], json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'password': password};
  }
}
