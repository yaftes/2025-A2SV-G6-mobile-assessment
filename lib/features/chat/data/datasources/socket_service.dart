import 'dart:async';
import 'package:g6_assessment/core/constants/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class SocketService {
  Future<void> connect(String token);

  void sendMessage({
    required String chatId,
    required String content,
    String type,
  });

  void onMessageReceived(Function(dynamic) callback);

  void onMessageDelivered(Function(dynamic) callback);

  Future<void> disconnect();
}

class SocketServiceImpl extends SocketService {
  late IO.Socket socket;

  @override
  Future<void> connect(String token) async {
    socket = IO.io(
      ChatApiConstants.forSocket,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    final completer = Completer<void>();

    socket.onConnect((_) {
      print('Socket connected');
      completer.complete();
    });

    socket.onConnectError((err) {
      print('Socket connection error: $err');
      if (!completer.isCompleted) completer.completeError(err);
    });

    socket.onError((err) {
      print('Socket error: $err');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });

    return completer.future;
  }

  @override
  void sendMessage({
    required String chatId,
    required String content,
    String type = 'text',
  }) {
    socket.emit('message:send', {
      'chatId': chatId,
      'content': content,
      'type': type,
    });
  }

  @override
  void onMessageReceived(Function(dynamic) callback) {
    socket.on('message:received', callback);
  }

  @override
  void onMessageDelivered(Function(dynamic) callback) {
    socket.on('message:delivered', callback);
  }

  @override
  Future<void> disconnect() async {
    socket.disconnect();
  }
}
