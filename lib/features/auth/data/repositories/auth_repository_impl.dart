import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/exceptions.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/core/platform/network_info.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:g6_assessment/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  AuthRepositoryImpl({
    required this.localDataSource,
    required this.networkInfo,
    required this.remoteDataSource,
  });
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(email, password);
        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      }
    }

    return Left(ServerFailure());
  }

  @override
  Future<Either<Failure, Unit>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> signUp(
    String name,
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUp(name, email, password);
        return Right(user);
      } catch (e) {
        return Left(ServerFailure());
      }
    }
    return Left(ServerFailure());
  }
}
