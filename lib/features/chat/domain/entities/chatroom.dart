import 'package:g6_assessment/features/chat/domain/entities/message.dart';

class Chatroom {
  String chatId;
  List<Message> messages;
  Chatroom({required this.chatId, required this.messages});
}
