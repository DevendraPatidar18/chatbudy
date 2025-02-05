

import 'package:chatbudy/core/usecase/GetMessagesUseCase.dart';
import 'package:chatbudy/domain/auth/repository/auth.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../core/usecase/user_usecase.dart';

class GetUserUseCaseimp implements GetUserUseCase<Stream<Either<String, DocumentSnapshot<Map<String,dynamic>>>>,String>{
  @override
  Stream<Either<String, DocumentSnapshot<Map<String,dynamic>>>> call({dynamic params}){
    return  sl<AuthRepository>().getUser();
  }

}