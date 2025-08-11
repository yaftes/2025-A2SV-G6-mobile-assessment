import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class InitiateChatUsecase {
  final ChatRepository repository;
  InitiateChatUsecase(this.repository);

  Future<Either<Failure, List<Chat>>> call(String receiverId) {
    return repository.initiateChat(receiverId);
  }
}
