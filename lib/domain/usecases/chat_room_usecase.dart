import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/domain/chat/repository/chat_room_repo.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:dartz/dartz.dart';

class ChatRoomUseCase implements UseCase<Either,String>{
  @override
  Future<Either> call({String? params}) async {
    return await sl<ChatRoomRepo>().getChatRoom(params!);
  }
}