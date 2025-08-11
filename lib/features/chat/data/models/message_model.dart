import 'package:g6_assessment/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({required String id, required String text})
    : super(id: id, text: text);

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String,
      text: json['content'] as String? ?? '',
    );
  }
}
