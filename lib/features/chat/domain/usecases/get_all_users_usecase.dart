import 'package:dartz/dartz.dart';
import 'package:g6_assessment/core/error/failures.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:g6_assessment/features/chat/domain/repositories/chat_repository.dart';

class GetAllUsersUsecase {
  final ChatRepository repository;
  GetAllUsersUsecase(this.repository);
  Future<Either<Failure, List<User>>> call() {
    return repository.getAllUsers();
  }
}
