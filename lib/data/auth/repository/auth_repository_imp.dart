import 'package:chatbudy/data/auth/models/user_creation_req.dart';
import 'package:chatbudy/data/auth/models/user_model.dart';
import 'package:chatbudy/data/auth/models/user_signin_req.dart';
import 'package:chatbudy/data/auth/source/auth_firebase_service.dart';
import 'package:chatbudy/domain/auth/entity/entity.dart';
import 'package:chatbudy/domain/auth/repository/auth.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';


class AuthRepositoryImp extends AuthRepository{
  @override
  Future<Either> signUp(UserCreationReq user) async {
   return await sl<AuthFirebaseService>().signUp(user);
  }

  @override
  Future<Either> signIn(UserSignInReq user) async {
    return await sl<AuthFirebaseService>().signIn(user);
  }
  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthFirebaseService>().isLoggedIn();
  }
  @override
  Stream<Either<String,DocumentSnapshot<Map<String,dynamic>>>> getUser() {
    var user = sl<AuthFirebaseService>().getUser().map<Either<String,DocumentSnapshot<Map<String,dynamic>>>>((data) => right(data))..handleError((error) => Left(error.toString()));
    return user;
  }
  @override
  Future<Either<String, UserEntity>> getUsers(String email) async {
    var user = await sl<AuthFirebaseService>().getUsers(email);
    return user.fold(
            (error){
          return left(error.toString());
        },
            (data){
          return right(UserModel.fromMap(data).toEntity());

        }
    );
  }
  @override
  Future<Either<String, UserEntity>> getUsersByUid(String uid) async {
    var user = await sl<AuthFirebaseService>().getUsersByUid(uid);
    return user.fold(
            (error){
          return left(error.toString());
        },
            (data){
          return right(UserModel.fromMap(data).toEntity());

        }
    );
  }

  @override
  Future<Either> updateUserProfile(Map<String, String> userdata) async {
    return await sl<AuthFirebaseService>().updateUserProfile(userdata);

  }

}