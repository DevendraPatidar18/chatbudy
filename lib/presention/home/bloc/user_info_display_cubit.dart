import 'dart:async';
import 'package:chatbudy/data/auth/models/user_model.dart';
import 'package:chatbudy/domain/usecases/get_user.dart';
import 'package:chatbudy/presention/home/bloc/user_info_diaplay_state.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class UserInfoDisplayCubit extends Cubit<UserInfoDisplayState>{
  StreamSubscription? _messageSubscription;
  UserInfoDisplayCubit() : super(UserInfoLoading());


  void displayUserInfo() async {
    _messageSubscription?.cancel();

    _messageSubscription = await sl<GetUserUseCaseimp>().call().listen(
          (result) {
        result.fold(
              (error) => emit(LoadUserInfoFailure()),
              (messages) => emit(UserInfoLoaded(userEntity: UserModel.fromMap(messages.data()!).toEntity())),
        );
      },
    );
  }
  @override
  Future<void> close() {
    _messageSubscription?.cancel(); // Cancel the stream on close
    return super.close();
  }
}

