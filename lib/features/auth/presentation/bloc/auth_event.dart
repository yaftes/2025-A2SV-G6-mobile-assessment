// here are the events performed by the user

import 'package:g6_assessment/features/auth/domain/entities/user.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  User user;
  LoginEvent(this.user);
}

class SignUpEvent extends AuthEvent {
  User user;
  SignUpEvent(this.user);
}

class LogoutEvent extends AuthEvent {}
