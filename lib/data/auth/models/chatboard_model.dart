class ChatBoardModel{
  final String Content;
  final String role;

  const ChatBoardModel({
    required this.Content,
    required this.role,
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'Content': this.Content,
      'role': this.role,
    };
  }

  factory ChatBoardModel.fromMap(Map<dynamic, dynamic> map) {
    return ChatBoardModel(
      Content: map['Content'] as String,
      role: map['role'] as String,
    );
  }
}