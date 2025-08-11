import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<Chat>>> myChats();

  Future<Either<Failure, Chat>> myChatById(String chatId);

  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);

  Future<Either<Failure, List<Chat>>> initiateChat(String receiverId);

  Future<Either<Failure, Unit>> deleteChat(String chatId);

  Future<Either<Failure, List<User>>> getAllUsers();

  Future<Either<Failure, Unit>> connectSocket(String token);
  Future<Either<Failure, Unit>> disconnectSocket();
  Future<Either<Failure, Unit>> sendMessage(
    String chatId,
    String content, {
    String type = 'text',
  });

  void onMessageReceived(Function(Message) callback);
  void onMessageDelivered(Function(Message) callback);
}
