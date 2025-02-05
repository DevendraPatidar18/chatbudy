

import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/data/auth/models/user_creation_req.dart';
import 'package:chatbudy/domain/auth/repository/auth.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:dartz/dartz.dart';

class SignupUseCase implements UseCase<Either,UserCreationReq>{
  @override
  Future<Either> call({UserCreationReq ? params})async {
    return await sl<AuthRepository>().signUp(params!);
  }

}