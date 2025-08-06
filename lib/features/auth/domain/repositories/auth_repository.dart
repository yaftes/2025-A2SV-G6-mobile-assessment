import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, Unit>> logout();
}
