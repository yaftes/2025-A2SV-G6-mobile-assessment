import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/exceptions.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/core/platform/network_info.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:g6_assessment/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(email, password);
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    }

    return Left(
      ServerFailure(message: 'Please check your internet connection'),
    );
  }

  @override
  Future<Either<Failure, User>> loginWithToken() async {
    if (await networkInfo.isConnected) {
      try {
        User user = await remoteDataSource.loginWithToken();
        return Right(user);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on CacheException {
        return Left(CacheFailure(message: 'Cache failure'));
      }
    } else {
      return Left(ServerFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.logout();
        return Right(unit);
      } on CacheException {
        return Left(CacheFailure(message: 'Cache failure'));
      }
    }
    return Left(
      ServerFailure(message: 'please check your internet connection'),
    );
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
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'Unexpected error occurred'));
      }
    }

    return Left(
      ServerFailure(message: 'Please check your internet connection'),
    );
  }
}
