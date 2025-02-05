
import 'package:chatbudy/data/auth/models/chatboard_model.dart';
import 'package:chatbudy/data/search_chat/models/chat_room_model.dart';
import 'package:chatbudy/domain/chat/repository/chat_room_repo.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:dartz/dartz.dart';

import '../models/message_model.dart';
import '../source/chat_room_service.dart';

class ChatRoomRepositoryImp extends ChatRoomRepo{
  @override
  Future<Either> getChatRoom(String email) async {
     var data = await sl<ChatRoomService>().getChatRoom(email);
     return data;
  }

  @override
  Future<Either> sendMessaage(String chatroomId,MessageModel messageModel) async {
    return await sl<ChatRoomService>().sendMessages(chatroomId ,messageModel);
  }

  @override
  Stream<Either<String,List<MessageModel>>> getMessage(String chatRoomId) {
    var data = sl<ChatRoomService>().getMessages(chatRoomId).map<Either<String, List<MessageModel>>>((messages) => Right(messages))
        .handleError((error) => Left(error.toString()));
   return data;
  }

  @override
  Stream<Either<String,List<ChatRoomModel>>> getChatroomList() {
    var data = sl<ChatRoomService>().getRecentChatroom().map<Either<String, List<ChatRoomModel>>>((chatRooms) => Right(chatRooms)).handleError((error) => left(error.toString()));
    return data;
  }
  Future<Either> getChatGptResponse(ChatBoardModel userMessage) async {
    return await sl<ChatRoomService>().fetchChatGPTResponse(userMessage);
  }
}