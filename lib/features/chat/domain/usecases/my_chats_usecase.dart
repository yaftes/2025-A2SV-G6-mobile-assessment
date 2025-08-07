import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class MyChatsUsecase {
  final ChatRepository repository;
  MyChatsUsecase(this.repository);

  Future<Either<Failure, List<Chat>>> call() {
    return repository.myChats();
  }
}
