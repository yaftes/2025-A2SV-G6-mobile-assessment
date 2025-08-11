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
