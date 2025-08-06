import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/core/platform/network_info.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:g6_assessment/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo;
  AuthRepositoryImpl(this.NetworkInfo);
  @override
  Future<Either<Failure, User>> login() {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signUp() {
    // TODO: implement signUp
    throw UnimplementedError();
  }
}
