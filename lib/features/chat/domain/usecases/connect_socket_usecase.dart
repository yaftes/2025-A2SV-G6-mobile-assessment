import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class ConnectSocketUsecase {
  final ChatRepository repository;

  ConnectSocketUsecase(this.repository);

  Future<Either<Failure, Unit>> call(String token) {
    return repository.connectSocket(token);
  }
}
