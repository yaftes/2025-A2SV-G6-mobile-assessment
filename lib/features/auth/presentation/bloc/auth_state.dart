import 'package:equatable/equatable.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends AuthState {}

// logged in or singed in
class UserDataFetchedState extends AuthState {
  final User user;
  UserDataFetchedState(this.user);
}

class ErrorState extends AuthState {
  final String message;
  ErrorState({required this.message});
}

class LoadingState extends AuthState {}

class LoggedOutState extends AuthState {}
