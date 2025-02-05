import 'package:chatbudy/domain/auth/entity/entity.dart';


abstract class UserInfoDisplayState{}

class UserInfoLoading extends UserInfoDisplayState{}

class UserInfoLoaded extends UserInfoDisplayState{
  final UserEntity userEntity;

  UserInfoLoaded({required this.userEntity});
}

class LoadUserInfoFailure extends UserInfoDisplayState{}