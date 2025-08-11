import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository repository;

  SendMessageUsecase(this.repository);

  Future<Either<Failure, Unit>> call(
    String chatId,
    String content, {
    String type = 'text',
  }) {
    return repository.sendMessage(chatId, content, type: type);
  }
}
