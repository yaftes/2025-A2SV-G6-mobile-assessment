import 'package:g6_assessment/features/chat/domain/entities/chat.dart';

abstract class ChatState {}

class InitalialState extends ChatState {}

class LoadingState extends ChatState {}

class ErrorState extends ChatState {
  String message;
  ErrorState({required this.message});
}

class ChatsLoadedState extends ChatState {
  List<Chat> chats;
  ChatsLoadedState({required this.chats});
}
