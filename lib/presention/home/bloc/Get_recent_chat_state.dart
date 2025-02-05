import 'package:chatbudy/data/search_chat/models/chat_room_model.dart';

abstract class GetRecentChatState{
  }
class Chatloaded extends GetRecentChatState{
  final List<ChatRoomModel> listOfChatRooms;
  Chatloaded({
    required this.listOfChatRooms,
  });
}
class ChatLoading extends GetRecentChatState{}
class ChatLoadedFaild extends GetRecentChatState{}