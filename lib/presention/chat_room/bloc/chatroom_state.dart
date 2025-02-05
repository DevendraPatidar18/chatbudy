import '../../../data/search_chat/models/chat_room_model.dart';

abstract class ChatRoomStates{}
class ChatRoomLoading extends ChatRoomStates{}

class ChatRoomLoaded extends ChatRoomStates{
  final ChatRoomModel chatRoom;

  ChatRoomLoaded({
    required this.chatRoom,
  });
}
class ChatRoomLoadFailed extends ChatRoomStates{}