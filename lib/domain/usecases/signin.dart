import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/data/auth/models/user_signin_req.dart';
import 'package:chatbudy/domain/auth/repository/auth.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:dartz/dartz.dart';

class SignInUseCase implements UseCase<Either,UserSignInReq>{
  @override
  Future<Either> call({UserSignInReq ? params})async {
    return await sl<AuthRepository>().signIn(params!);
  }

}