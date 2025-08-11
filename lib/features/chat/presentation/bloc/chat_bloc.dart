import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_assessment/features/chat/domain/usecases/connect_socket_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/delete_chat_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/disconnect_socket_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/get_all_users_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/initiate_chat_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/my_chat_by_id_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/my_chats_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_event.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MyChatsUsecase myChatsUsecase;
  final DeleteChatUsecase deleteChatUsecase;
  final InitiateChatUsecase initiateChatUsecase;
  final MyChatByIdUsecase myChatByIdUsecase;
  final GetMessagesUsecase getMessagesUsecase;
  final GetAllUsersUsecase getAllUsersUsecase;
  final ConnectSocketUsecase connectSocketUsecase;
  final DisconnectSocketUsecase disconnectSocketUsecase;
  final SendMessageUsecase sendMessageUsecase;

  ChatBloc({
    required this.deleteChatUsecase,
    required this.getMessagesUsecase,
    required this.initiateChatUsecase,
    required this.myChatByIdUsecase,
    required this.myChatsUsecase,
    required this.getAllUsersUsecase,
    required this.connectSocketUsecase,
    required this.disconnectSocketUsecase,
    required this.sendMessageUsecase,
  }) : super(InitialState()) {
    on<LoadChatEvent>((event, emit) async {
      emit(ChatsLoadingState());
      final result = await myChatsUsecase();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(ChatsLoadedState(chats: success)),
      );
    });

    on<LoadAllUsersEvent>((event, emit) async {
      emit(UsersLoadingState());
      final result = await getAllUsersUsecase();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(LoadedUsersState(success)),
      );
    });

    on<InitiateChatEvent>((event, emit) async {
      emit(ChatsLoadingState());
      final result = await initiateChatUsecase(event.userId);
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(ChatsLoadedState(chats: success)),
      );
    });

    on<LoadAllChatMessages>((event, emit) async {
      emit(LoadingState());
      final result = await getMessagesUsecase(event.chatId);
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(GetChatMessagesState(success)),
      );
    });

    on<ConnectSocketEvent>((event, emit) async {
      emit(SocketConnectingState());
      final result = await connectSocketUsecase(event.token);
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (_) => emit(SocketConnectedState()),
      );
    });

    on<SendMessageEvent>((event, emit) async {
      emit(MessageSendingState());

      final sendResult = await sendMessageUsecase(
        event.chatId,
        event.content,
        type: event.type,
      );

      if (sendResult.isLeft()) {
        sendResult.fold(
          (failure) => emit(ErrorState(message: failure.message)),
          (_) => null,
        );
        return;
      }

      emit(MessageSentState());

      final messagesResult = await getMessagesUsecase(event.chatId);
      messagesResult.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (messages) => emit(GetChatMessagesState(messages)),
      );
    });
  }
}
