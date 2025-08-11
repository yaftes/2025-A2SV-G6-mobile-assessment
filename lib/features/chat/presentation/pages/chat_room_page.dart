import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:g6_assessment/features/chat/domain/entities/chat.dart';
import 'package:g6_assessment/features/chat/domain/entities/message.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_event.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_state.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Chat? chatData;
  String? receiverUserName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (chatData == null) {
      chatData = ModalRoute.of(context)!.settings.arguments as Chat;
      receiverUserName = chatData!.receiverName;
      context.read<ChatBloc>().add(LoadAllChatMessages(chatData!.chatId));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is MessageSentState) {
          _messageController.clear();
          _scrollToBottom();
        } else if (state is ErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is GetChatMessagesState) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        List<Message> messages = [];
        if (state is GetChatMessagesState) {
          messages = state.messages;
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 243, 243, 243),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 243, 243, 243),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjDGMp734S91sDuUFqL51_xRTXS15iiRoHew&s',
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receiverUserName ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Text(
                      '8 member',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 15),
                child: Row(
                  children: [
                    Icon(Icons.call_outlined, color: Colors.black),
                    SizedBox(width: 15),
                    Icon(Icons.video_call, color: Colors.black),
                  ],
                ),
              ),
            ],
          ),
          body: state is GetChatMessagesState
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - 1 - index];
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                message.text ?? '',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _buildMessageInput(),
                  ],
                )
              : const Center(child: SpinKitDoubleBounce(color: Colors.blue)),
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.link),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: _messageController,
              decoration: InputDecoration(
                fillColor: const Color(0xffE7E6E6),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Write your message here',
                suffixIcon: const Icon(
                  Icons.image_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.camera_alt),
          const SizedBox(width: 10),
          const Icon(Icons.mic),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = _messageController.text.trim();
              if (text.isNotEmpty && chatData != null) {
                context.read<ChatBloc>().add(
                  SendMessageEvent(chatId: chatData!.chatId, content: text),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
