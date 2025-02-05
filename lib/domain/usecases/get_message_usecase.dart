import 'package:chatbudy/core/usecase/GetMessagesUseCase.dart';
import 'package:chatbudy/domain/chat/repository/chat_room_repo.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:dartz/dartz.dart';

import '../../data/search_chat/models/message_model.dart';

class GetMessageUseCaseImpl implements GetMessageUseCase< Stream<Either<String, List<MessageModel>>>,String>{
  @override
  Stream<Either<String, List<MessageModel>>> call({String? params})  {
    return  sl<ChatRoomRepo>().getMessage(params!);
  }

}