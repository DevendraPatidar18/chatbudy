

import 'package:chatbudy/core/usecase/gpt_usecase.dart';
import 'package:chatbudy/data/auth/models/chatboard_model.dart';
import 'package:chatbudy/domain/usecases/get_chatgpt_response_usecase.dart';
import 'package:chatbudy/presention/chatbot/bloc/get_response_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import '../../../servicelocator.dart';

class GetResponseCubit extends Cubit<GptResponseState>{
  GetResponseCubit() : super(ResponseLoading());

  void getResponse(ChatBoardModel userMessage) async {
    List<ChatBoardModel> listChats = [];
    listChats.add(userMessage);
    var data = await sl<GetChatGptResponseUseCase>().call(params: userMessage);
    data.fold(
        (error){
          emit(ResponseFailed());
        },
          (data){
          listChats.add(data);
          print('data in cubit');
          emit(ResponseLoaded(responseList: listChats));
    }
    );


  }
}