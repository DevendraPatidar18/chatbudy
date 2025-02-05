import '../../../data/search_chat/models/message_model.dart';

abstract class GetMessagesState {}

class MessagesLoading extends GetMessagesState {}

class MessagesLoaded extends GetMessagesState {
  final List<MessageModel> messagesSnapshots;
  MessagesLoaded({required this.messagesSnapshots});
}

class MessagesLoadingFaild extends GetMessagesState {
  final String errorMessage;
  MessagesLoadingFaild({required this.errorMessage});
}
