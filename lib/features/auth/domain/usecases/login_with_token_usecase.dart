import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:g6_assessment/features/auth/domain/repositories/auth_repository.dart';

class LoginWithTokenUsecase {
  final AuthRepository repository;

  LoginWithTokenUsecase(this.repository);

  Future<Either<Failure, User>> call() {
    return repository.loginWithToken();
  }
}
