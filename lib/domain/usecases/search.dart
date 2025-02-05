

import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/domain/auth/repository/auth.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:dartz/dartz.dart';

class GetFirebaseUsersUseCase implements UseCase<Either,String>{
  @override
  Future<Either> call({String? params}) async {
    if(params!.contains('@')){
      return await sl<AuthRepository>().getUsers(params);
    }else{
      var data =  await sl<AuthRepository>().getUsersByUid(params);
      print('Data in Use case ${data.toString()}');
      return data;
    }
  }


}