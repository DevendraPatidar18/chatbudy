import 'dart:async';
import 'package:chatbudy/core/usecase/GetMessagesUseCase.dart';
import 'package:chatbudy/presention/chat_room/bloc/getmessages_state.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetMessagesCubit extends Cubit<GetMessagesState> {
  StreamSubscription? _messageSubscription;

  GetMessagesCubit() : super(MessagesLoading());

  void subscribeToMessages(String chatRoomId) {
    _messageSubscription?.cancel(); // Cancel any existing subscription

    // Listen to the message stream for real-time updates
    _messageSubscription = sl<GetMessageUseCase>().call(params: chatRoomId).listen(
          (result) {
        result.fold(
              (error) => emit(MessagesLoadingFaild(errorMessage: error)),
              (messages) => emit(MessagesLoaded(messagesSnapshots: messages)),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel(); // Cancel the stream on close
    return super.close();
  }
}

