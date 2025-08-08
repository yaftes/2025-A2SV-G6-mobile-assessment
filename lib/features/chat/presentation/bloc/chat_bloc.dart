import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:g6_assessment/features/chat/domain/usecases/delete_chat_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/initiate_chat_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/my_chat_by_id_usecase.dart';
import 'package:g6_assessment/features/chat/domain/usecases/my_chats_usecase.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_event.dart';
import 'package:g6_assessment/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final MyChatsUsecase myChatsUsecase;
  final DeleteChatUsecase deleteChatUsecase;
  final InitiateChatUsecase initiateChatUsecase;
  final MyChatByIdUsecase myChatByIdUsecase;
  final GetMessagesUsecase getMessagesUsecase;
  ChatBloc({
    required this.deleteChatUsecase,
    required this.getMessagesUsecase,
    required this.initiateChatUsecase,
    required this.myChatByIdUsecase,
    required this.myChatsUsecase,
  }) : super(InitalialState()) {
    on<LoadChatEvent>((event, emit) async {
      emit(LoadingState());
      final result = await myChatsUsecase();
      result.fold(
        (failure) => emit(ErrorState(message: failure.message)),
        (success) => emit(ChatsLoadedState(chats: success)),
      );
    });
  }
}
