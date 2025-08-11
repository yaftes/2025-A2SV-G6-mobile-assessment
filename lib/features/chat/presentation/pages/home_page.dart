import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_event.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_state.dart';
import 'package:g6_assessment/features/chat/presentation/widgets/custom_avatar_widget.dart';
import 'package:g6_assessment/features/chat/presentation/widgets/custom_list_tile_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadAllUsersEvent());
    context.read<ChatBloc>().add(LoadChatEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: screenHeight / 3.5,
            decoration: const BoxDecoration(color: Colors.blue),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Icon(Icons.search, color: Colors.white, size: 32),
                  BlocBuilder<ChatBloc, ChatState>(
                    buildWhen: (previous, current) =>
                        current is LoadedUsersState ||
                        current is UsersLoadingState ||
                        current is ErrorState,
                    builder: (context, state) {
                      if (state is UsersLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ErrorState) {
                        return Center(child: Text(state.message));
                      } else if (state is LoadedUsersState) {
                        final users = state.users;
                        return users.isEmpty
                            ? const Center(
                                child: Text('No available users for now'),
                              )
                            : Center(
                                child: SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    itemCount: users.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final user = users[index];
                                      return GestureDetector(
                                        onTap: () {
                                          context.read<ChatBloc>().add(
                                            InitiateChatEvent(user.id!),
                                          );
                                        },
                                        child: CustomAvatarWidget(
                                          backgroundColor: Colors.amber,
                                          borderColor: Colors.amberAccent,
                                          imageUrl:
                                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjDGMp734S91sDuUFqL51_xRTXS15iiRoHew&s',
                                          name: user.name ?? '',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
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
              child: BlocBuilder<ChatBloc, ChatState>(
                buildWhen: (previous, current) =>
                    current is ChatsLoadedState ||
                    current is ChatsLoadingState ||
                    current is ErrorState,
                builder: (context, state) {
                  if (state is ChatsLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ErrorState) {
                    return Center(child: Text(state.message));
                  } else if (state is ChatsLoadedState) {
                    final chats = state.chats;
                    return chats.isEmpty
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

                              /* : TODO
                              so here we extract the chatroom id and we navigate to 
                              a detail page for chat message page 
                              */
                              return CustomListTileWidget(
                                imageUrl:
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQjDGMp734S91sDuUFqL51_xRTXS15iiRoHew&s',
                                name: chat.receiverName,
                                lastMessage: 'last message',
                                lastSeen: '2 min ago',
                                unReadMessage: 3,
                              );
                            },
                          );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
