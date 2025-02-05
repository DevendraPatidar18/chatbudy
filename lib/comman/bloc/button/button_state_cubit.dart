import 'package:chatbudy/comman/bloc/button/button_state.dart';
import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ButtonStateCubit extends Cubit<ButtonStates>{

  ButtonStateCubit() : super(ButtonInitializeState());

  Future<void> execute({dynamic params, required UseCase useCase}) async {
    emit(ButtonLoadingState());
    try{
      Either returnedData = await useCase.call(params: params);
      returnedData.fold(
              (error){
            emit(ButtonFailureState(
                errorMessage: error
            ));
          },
              (data){
            emit(ButtonSuccessState());
          });
    }catch(e){
      emit(ButtonFailureState(
          errorMessage: e.toString()
      ));
    }
  }

}