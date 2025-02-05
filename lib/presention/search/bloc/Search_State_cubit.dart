
import 'package:chatbudy/domain/auth/entity/entity.dart';
import 'package:chatbudy/domain/usecases/search.dart';
import 'package:chatbudy/presention/search/bloc/search_state.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchStateCubit extends Cubit<SearchState>{
  SearchStateCubit() : super(SearchStateLoading());

  void searchUser(String searchText) async {
    var returnedData =/* await sl<GetFirebaseUsersUseCase>().call();*/
    await sl<GetFirebaseUsersUseCase>().call(params: searchText);

    returnedData.fold(
            (error){
          emit(SearchStateFailed(errorMessage: error));
        },
            (data){
              print('target User data in search cubit ${data.toString()}');
          emit(SearchStateLoadedSuccessfull(userEntity: data)
          );
        });
  }
  Future<UserEntity> searchUserByUid(String uid) async {
    var returnedData = await sl<GetFirebaseUsersUseCase>().call(params: uid);
    var user;
    returnedData.fold(
        (error){
          print('data not loaded');
        },
        (data){
          user = data;
        }
    );
    return user;

  }
}