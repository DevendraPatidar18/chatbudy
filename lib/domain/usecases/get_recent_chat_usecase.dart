import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/data/search_chat/models/chat_room_model.dart';
import 'package:chatbudy/domain/chat/repository/chat_room_repo.dart';
import 'package:dartz/dartz.dart';

import '../../core/usecase/get_recent_chat_usecase.dart';
import '../../servicelocator.dart';

class GetRecentChatUseCaseImp extends GetRecentChatUseCase<Stream<Either<String,List<ChatRoomModel>>>, String>{

  Stream<Either<String, List<ChatRoomModel>>> call({String? params})  {
    return sl<ChatRoomRepo>().getChatroomList();
  }
}