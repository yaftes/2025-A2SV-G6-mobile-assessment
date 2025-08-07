import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/chat/domain/entities/message.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class GetMessagesUsecase {
  final ChatRepository repository;
  GetMessagesUsecase(this.repository);

  Future<Either<Failure, List<Message>>> call(String chatId) {
    return repository.getChatMessages(chatId);
  }
}
