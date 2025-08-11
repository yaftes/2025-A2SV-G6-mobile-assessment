import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_event.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_state.dart';
import 'package:g6_assessment/features/chat/presentation/widgets/custom_avatar_widget.dart';
import 'package:g6_assessment/features/chat/presentation/widgets/custom_list_tile_widget.dart';

// here we show a list of users and chats
// a list of chat current user involved in
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadChatEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ErrorState) {
            return Center(child: Text(state.message));
          } else if (state is ChatsLoadedState) {
            final chats = state.chats;
            return Column(
              children: [
                Container(
                  height: screenHeight / 3.5,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: chats.isEmpty
                      ? Center(child: Text('No available chats for now'))
                      : ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (context, index) {
                            return CustomAvatarWidget(
                              backgroundColor: Colors.amber,
                              borderColor: Colors.amberAccent,
                              imageUrl: '',
                              name: chats[index].senderName,
                            );
                          },
                        ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: chats.isEmpty
                        ? const Center(
                            child: Text(
                              'No Available chats for now',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        : ListView.builder(
                            itemCount: chats.length,
                            itemBuilder: (context, index) {
                              final chat = chats[index];
                              return CustomListTileWidget(
                                imageUrl: '',
                                name: chat.senderName,
                                lastMessage: '',
                                lastSeen: '',
                              );
                            },
                          ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink(); // default empty widget
        },
      ),
    );
  }
}
