import 'package:chatbudy/data/auth/models/user_creation_req.dart';
import 'package:chatbudy/data/auth/models/user_signin_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either> signUp(UserCreationReq user);
  Future<Either> signIn(UserSignInReq user);
  Future<bool> isLoggedIn();
  Stream<Either<String,DocumentSnapshot<Map<String,dynamic>>>> getUser();
  Future<Either> getUsers(String email);
  Future<Either> getUsersByUid(String uid);
  Future<Either> updateUserProfile(Map<String,String> userdata);

}