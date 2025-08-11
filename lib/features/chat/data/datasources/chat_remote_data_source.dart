import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:g6_assessment/core/constants/constants.dart';
import 'package:g6_assessment/core/error/exceptions.dart';
import 'package:g6_assessment/features/auth/data/models/user_model.dart';
import 'package:g6_assessment/features/auth/domain/entities/user.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/entities/message.dart';
import 'package:http/http.dart' as http;

abstract class ChatRemoteDataSource {
  Future<List<Chat>> myChats();
  Future<Chat> myChatById(String chatId);
  Future<List<Message>> getChatMessages(String chatId);
  Future<List<Chat>> initiateChat(String receiverId);
  Future<void> deleteChat(String chatId);

  Future<List<User>> getAllUsers();
}

class ChatRemoteDataSourceImpl extends ChatRemoteDataSource {
  final http.Client client;
  final FlutterSecureStorage storage;
  ChatRemoteDataSourceImpl(this.client, this.storage);

  @override
  Future<void> deleteChat(String chatId) async {
    try {
      final token = await storage.read(key: StorageKeys.accessToken);

      if (token == null || token.isEmpty) {
        throw CacheException();
      }

      final response = await client.get(
        Uri.parse('${ChatApiConstants.chatUrl}$chatId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(response.body);
      }
    } catch (e) {
      throw ServerException('');
    }
  }

  @override
  Future<List<Message>> getChatMessages(String chatId) async {
    try {
      final token = await storage.read(key: StorageKeys.accessToken);

      if (token == null || token.isEmpty) {
        throw CacheException();
      }

      final response = await client.get(
        Uri.parse('${ChatApiConstants.chatUrl}/$chatId/messages'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(response.body);
      }

      final jsonData = jsonDecode(response.body);

      if (jsonData['statusCode'] != 200) {
        throw ServerException(jsonData['message'] ?? 'Unknown error');
      }

      final List<dynamic> messagesJson = jsonData['data'];

      final messages = messagesJson.map((msg) {
        return Message(
          id: msg['_id'],
          senderId: msg['sender']['_id'],
          receiverId: msg['chat']['user1']['_id'] == msg['sender']['_id']
              ? msg['chat']['user2']['_id']
              : msg['chat']['user1']['_id'],
          text: msg['content'],
        );
      }).toList();

      return messages;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Chat>> initiateChat(String receiverId) async {
    try {
      final token = await storage.read(key: StorageKeys.accessToken);

      if (token == null || token.isEmpty) {
        throw CacheException();
      }

      final response = await client.post(
        Uri.parse(ChatApiConstants.chatUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'userId': receiverId}),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(response.body);
      }

      return await myChats();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Chat> myChatById(String chatId) async {
    try {
      final token = await storage.read(key: StorageKeys.accessToken);

      if (token == null || token.isEmpty) {
        throw CacheException();
      }

      final response = await client.get(
        Uri.parse('${ChatApiConstants.chatUrl}/$chatId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(response.body);
      }

      final Map<String, dynamic> decoded = jsonDecode(response.body);
      final Map<String, dynamic> chatData = decoded['data'];

      return Chat(
        chatId: chatData['_id'],
        senderId: chatData['user1']['_id'],
        senderName: chatData['user1']['name'],
        receiverId: chatData['user2']['_id'],
        receiverName: chatData['user2']['name'],
      );
    } catch (e) {
      throw ServerException('');
    }
  }

  @override
  Future<List<Chat>> myChats() async {
    try {
      final token = await storage.read(key: StorageKeys.accessToken);

      if (token == null || token.isEmpty) {
        throw CacheException();
      }

      final response = await client.get(
        Uri.parse(ChatApiConstants.chatUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(response.body);
      }

      final Map<String, dynamic> decoded = jsonDecode(response.body);

      final List<dynamic> data = decoded['data'];

      final chats = data.map((chat) {
        return Chat(
          chatId: chat['_id'],
          senderId: chat['user1']['_id'],
          senderName: chat['user1']['name'],
          receiverId: chat['user2']['_id'],
          receiverName: chat['user2']['name'],
        );
      }).toList();

      return chats;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<User>> getAllUsers() async {
    try {
      final token = await storage.read(key: StorageKeys.accessToken);

      if (token == null || token.isEmpty) {
        throw CacheException();
      }

      final response = await client.get(
        Uri.parse(ChatApiConstants.getUsers),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(response.body);
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> usersJson = decoded['data'];

      return usersJson
          .map(
            (user) => UserModel(
              id: user['_id'],
              name: user['name'],
              email: user['email'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
