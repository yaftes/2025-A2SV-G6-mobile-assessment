import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/entities/message.dart';

abstract class ChatState {}

class InitialState extends ChatState {}

class UsersLoadingState extends ChatState {}

class LoadedUsersState extends ChatState {
  final List<User> users;
  LoadedUsersState(this.users);
}

class ChatsLoadingState extends ChatState {}

class ChatsLoadedState extends ChatState {
  final List<Chat> chats;
  ChatsLoadedState({required this.chats});
}

class ErrorState extends ChatState {
  final String message;
  ErrorState({required this.message});
}

class GetChatMessagesState extends ChatState {
  List<Message> messages;
  GetChatMessagesState(this.messages);
}

class LoadingState extends ChatState {}
