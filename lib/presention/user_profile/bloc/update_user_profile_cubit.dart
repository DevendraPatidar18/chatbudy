

import 'package:chatbudy/domain/usecases/update_user_profile_usecase.dart';
import 'package:chatbudy/presention/user_profile/bloc/update_use_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../servicelocator.dart';

class UpdateUserProfileCubit extends Cubit<UpdateUserProfileState>{
  UpdateUserProfileCubit() : super(UpdatingUserProfile());

  void updateUserProfile(Map<String,String> userData) async {
    print('update user cubit');
    var data = await sl<UpdateUserProfileUseCase>().call(params: userData);

  }

}
