class ChatRoomModel{
  final String chatRoomId;
  final Map<String,dynamic> participants;

  ChatRoomModel({
    required this.chatRoomId,
    required this.participants,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': this.chatRoomId,
      'participants': this.participants,
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      chatRoomId: map['chatRoomId'] as String,
      participants: map['participants'] as Map<String, dynamic>,
    );
  }
}