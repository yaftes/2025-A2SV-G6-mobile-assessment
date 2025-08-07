import 'package:g6_assessment/features/chat/domain/entities/message.dart';

class Chat {
  String chatId;
  String senderId;
  String senderName;
  String receiverId;
  String receiverName;
  Chat({
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.senderName,
  });
}
