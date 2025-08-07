import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  // :-> fetch chats for current user
  Future<Either<Failure, List<Chat>>> myChats();

  // :-> get the chat

  Future<Either<Failure, Chat>> myChatById(String chatId);

  // :-> fetch chat messages for that
  Future<Either<Failure, List<Message>>> getChatMessages(String chatId);

  // :->
  Future<Either<Failure, Unit>> initiateChat(String receiverId);

  // :->
  Future<Either<Failure, Unit>> deleteChat(String chatId);
}
