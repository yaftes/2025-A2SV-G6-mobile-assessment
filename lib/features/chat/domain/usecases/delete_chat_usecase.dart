import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class DeleteChatUsecase {
  final ChatRepository repository;
  DeleteChatUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String chatId) {
    return repository.deleteChat(chatId);
  }
}
