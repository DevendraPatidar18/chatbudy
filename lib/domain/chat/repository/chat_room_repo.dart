import 'package:chatbudy/data/auth/models/chatboard_model.dart';
import 'package:chatbudy/data/search_chat/models/chat_room_model.dart';
import 'package:chatbudy/domain/auth/entity/entity.dart';
import 'package:dartz/dartz.dart';

import '../../../data/search_chat/models/message_model.dart';

abstract class ChatRoomRepo{
  Future<Either> getChatRoom(String email);
  Future<Either> sendMessaage(String chatroomId,MessageModel messageModel);
  Stream<Either<String,List<MessageModel>>> getMessage(String chatRoomId);
  Stream<Either<String,List<ChatRoomModel>>> getChatroomList();
  Future<Either> getChatGptResponse(ChatBoardModel userMessage);
}