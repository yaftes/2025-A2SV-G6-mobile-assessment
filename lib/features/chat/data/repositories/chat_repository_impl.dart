import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/exceptions.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/core/platform/network_info.dart';
import 'package:g6_assessment/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/entities/message.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  ChatRepositoryImpl(this.remoteDataSource, this.networkInfo);
  @override
  Future<Either<Failure, Unit>> deleteChat(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteChat(chatId);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    }
    return Left(ServerFailure(message: 'Please Connect to internet'));
  }

  @override
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getChatMessages(chatId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    }

    return Left(ServerFailure(message: 'Please Connect to internet'));
  }

  @override
  Future<Either<Failure, Unit>> initiateChat(String receiverId) async {
    if (await networkInfo.isConnected) {
      try {
        remoteDataSource.initiateChat(receiverId);
        return Right(unit);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    }

    return Left(ServerFailure(message: 'Please Connect to internet'));
  }

  @override
  Future<Either<Failure, Chat>> myChatById(String chatId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.myChatById(chatId);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    }

    return Left(ServerFailure(message: 'Please Connect to internet'));
  }

  @override
  Future<Either<Failure, List<Chat>>> myChats() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.myChats();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    }

    return Left(ServerFailure(message: 'Please Connect to internet'));
  }
}
