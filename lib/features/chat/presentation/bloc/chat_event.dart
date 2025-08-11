import 'package:g6_assessment/features/chat/domain/entities/message.dart';

abstract class ChatEvent {}

class LoadChatEvent extends ChatEvent {}

class LoadAllUsersEvent extends ChatEvent {}

class InitiateChatEvent extends ChatEvent {
  final String userId;
  InitiateChatEvent(this.userId);
}

class LoadAllChatMessages extends ChatEvent {
  String chatId;
  LoadAllChatMessages(this.chatId);
}

// ================ Socket events

class ConnectSocketEvent extends ChatEvent {
  final String token;
  ConnectSocketEvent(this.token);
}

class DisconnectSocketEvent extends ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String content;
  final String type;

  SendMessageEvent({
    required this.chatId,
    required this.content,
    this.type = 'text',
  });
}

class MessageReceivedEvent extends ChatEvent {
  final Message message;
  MessageReceivedEvent(this.message);
}
