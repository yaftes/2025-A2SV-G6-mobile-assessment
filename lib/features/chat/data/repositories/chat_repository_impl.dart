import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/exceptions.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/core/platform/network_info.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:g6_assessment/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:g6_assessment/features/chat/data/datasources/socket_service.dart';
import 'package:g6_assessment/features/chat/data/models/message_model.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/entities/message.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SocketService socketService;
  ChatRepositoryImpl(
    this.remoteDataSource,
    this.networkInfo,
    this.socketService,
  );

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
  Future<Either<Failure, List<Chat>>> initiateChat(String receiverId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.initiateChat(receiverId);
        return Right(result);
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

  @override
  Future<Either<Failure, List<User>>> getAllUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAllUsers();
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(message: e.message));
      }
    }
    return Left(ServerFailure(message: 'Please Connect to internet'));
  }

  @override
  Future<Either<Failure, Unit>> connectSocket(String token) async {
    try {
      await socketService.connect(token);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> disconnectSocket() async {
    try {
      await socketService.disconnect();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(
    String chatId,
    String content, {
    String type = 'text',
  }) async {
    try {
      socketService.sendMessage(chatId: chatId, content: content, type: type);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  void onMessageReceived(Function(Message) callback) {
    socketService.onMessageReceived((data) {
      final message = MessageModel.fromJson(data);
      callback(message);
    });
  }

  @override
  void onMessageDelivered(Function(Message) callback) {
    socketService.onMessageDelivered((data) {
      final message = MessageModel.fromJson(data);
      callback(message);
    });
  }
}
