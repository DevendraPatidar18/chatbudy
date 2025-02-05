import 'dart:ffi';

import 'package:chatbudy/domain/auth/entity/entity.dart';
import 'package:chatbudy/domain/usecases/chat_room_usecase.dart';
import 'package:chatbudy/presention/chat_room/bloc/chatroom_state.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomStateCubit extends Cubit<ChatRoomStates>{
  ChatRoomStateCubit () : super(ChatRoomLoading());
  void getData(String email) async {
    var data = await sl<ChatRoomUseCase>().call(params: email);
    data.fold(
            (error)
        {
          emit(ChatRoomLoadFailed());
        } ,
            (data) {
              emit(ChatRoomLoaded(chatRoom: data));
            }
    );
  }
}

