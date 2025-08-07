import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class MyChatByIdUsecase {
  final ChatRepository repository;
  MyChatByIdUsecase(this.repository);

  Future<Either<Failure, Chat>> call(String chatId) {
    return repository.myChatById(chatId);
  }
}
