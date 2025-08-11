import 'package:equatable/equatable.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

// initial and error states

class InitialState extends AuthState {}

class ErrorState extends AuthState {
  final String message;
  ErrorState({required this.message});
}

class LoadingState extends AuthState {}

// different state for user in auth
class LoggedOutState extends AuthState {}

class SignedUpState extends AuthState {}

class LoggedInState extends AuthState {
  final User user;
  LoggedInState(this.user);
}

class AuthMessageState extends AuthState {
  final String message;
  AuthMessageState(this.message);
}

// connection state

class ConnectedState extends AuthState {}

class DisConnectedState extends AuthState {}
