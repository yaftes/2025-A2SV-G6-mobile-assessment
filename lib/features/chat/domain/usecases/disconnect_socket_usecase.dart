import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class DisconnectSocketUsecase {
  final ChatRepository repository;

  DisconnectSocketUsecase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.disconnectSocket();
  }
}
