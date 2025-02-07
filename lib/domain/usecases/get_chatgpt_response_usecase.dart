import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/domain/chat/repository/chat_room_repo.dart';
import 'package:dartz/dartz.dart';
import '../../servicelocator.dart';


class GetChatGptResponseUseCase extends UseCase<Either ,dynamic> {
  @override
  Future<Either> call({dynamic params})async {
    var data = await sl<ChatRoomRepo>().getChatGptResponse(params);
    return data;
}
}
