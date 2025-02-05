import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/domain/auth/repository/auth.dart';
import 'package:dartz/dartz.dart';

import '../../servicelocator.dart';

class UpdateUserProfileUseCase extends UseCase<Either,dynamic>{
  @override
  Future<Either> call({params}) async {
    return  await sl<AuthRepository>().updateUserProfile(params);

  }


}
