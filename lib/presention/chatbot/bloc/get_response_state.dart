import 'package:chatbudy/data/auth/models/chatboard_model.dart';

abstract class GptResponseState{}

class ResponseLoading extends GptResponseState {}
class ResponseLoaded extends GptResponseState {

  final List<ChatBoardModel> responseList;

  ResponseLoaded({

    required this.responseList
  });

}
class ResponseFailed extends GptResponseState {}