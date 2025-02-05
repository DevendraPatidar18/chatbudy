import 'package:chatbudy/core/usecase/MessageUseCase.dart';
import 'package:chatbudy/domain/chat/repository/chat_room_repo.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:dartz/dartz.dart';

import '../../data/search_chat/models/message_model.dart';

class SendMessageUseCase extends MessageUseCase<Either,String,MessageModel>{
  @override
  Future<Either> call({String? params, MessageModel? params1}) async {
    return await sl<ChatRoomRepo>().sendMessaage(params!, params1!);
  }
}

