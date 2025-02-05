import 'dart:async';

import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/data/search_chat/models/chat_room_model.dart';
import 'package:chatbudy/domain/usecases/get_recent_chat_usecase.dart';
import 'package:chatbudy/presention/home/bloc/Get_recent_chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../servicelocator.dart';

class GetRecentChatCubit extends Cubit<GetRecentChatState>{
  StreamSubscription? _recentChatSubscription;
  GetRecentChatCubit() : super(ChatLoading());

  void getTargetUserData() async {
    _recentChatSubscription?.cancel();
    _recentChatSubscription = await sl<GetRecentChatUseCaseImp>().call().listen(
            (result) {
              print(result.toString());
              result.fold(
                      (error) => emit(ChatLoadedFaild()),
                      (r) => emit(Chatloaded(listOfChatRooms: r)));
            });

  }
  @override
  Future<void> close() {
    _recentChatSubscription?.cancel(); // Cancel the stream on close
    return super.close();
  }
}