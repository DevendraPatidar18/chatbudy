import 'package:chatbudy/data/auth/models/user_creation_req.dart';
import 'package:chatbudy/data/auth/models/user_signin_req.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthFirebaseService {
  Future<Either> signUp(UserCreationReq user);

  Future<Either> signIn(UserSignInReq user);

  Future<bool> isLoggedIn();

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser();

  Future<Either> getUsers(String email);

  Future<Either> getUsersByUid(String email);

  Future<Either> updateUserProfile(Map<String, String> userdata);
}


class AuthFirebaseServiceImp extends AuthFirebaseService {
  @override
  Future<Either> signUp(UserCreationReq user) async {
    try {
      var returnedData =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(returnedData.user!.uid)
          .set({
        'name': user.name,
        'email': user.email,
        'uid' : returnedData.user!.uid,
      });
      return const Right('SignUp was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'This password is provided is so weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email is already in use';
      }
      return left(message);
    }
  }

  @override
  Future<Either> signIn(UserSignInReq user) async {
    try{
      var returnedData = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: user.email!,
          password: user.password!
      );
      return right('SignIn Successful');
    }on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'Not user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong Password';
      }
      return left(message);
    }
  }
  @override
  Future<bool> isLoggedIn() async {
    bool? flag = false;
    print('Cheking the user credential');
    await FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        flag = true;
      } else {
        flag = false;
      }
    });
    return flag!;
  }
  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser()  {

      var currentUser = FirebaseAuth.instance.currentUser;
      var userData =  FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser?.uid).snapshots();
         /* .get()
          .then((value) => value.data());*/
      return userData;
  }

  @override
  Future<Either<String, Map<String, dynamic>>> getUsers(String email) async {
    try{
      var users = await FirebaseFirestore.instance.collection('Users').where('email',isEqualTo: email ).get();

      return right(users.docs.first.data());
    }catch(e){
      return left('Please try again');
    }

  }

  @override
  Future<Either<String, Map<String, dynamic>>> getUsersByUid(String uid) async {
    print('hello from auth service');
    try{
      var users = await FirebaseFirestore.instance.collection('Users').where('uid',isEqualTo: uid ).get();
      if (users.docs.isEmpty) {
        print('No user found with the given UID');
      }

      print(users.docs.length);
      print(users.docs.first.data());
      return right(/*users.docs.first.data()*/users.docs.first.data());
    }catch(e){
      print(e.toString());
      return left('Please try again');
    }

  }

  @override
  Future<Either<String,Map<String,dynamic>>> updateUserProfile(Map<String, String> userdata) async {
    print('update user service $userdata');
    try {
      if (userdata['username'] != null && userdata['bio'] != null && userdata['uid'] != null) {
        FirebaseFirestore.instance
            .collection('Users').doc(userdata['uid']).update(
            {
              'name': userdata['username'],
              'bio': userdata['bio']
            });
      }
      var updatedData = await FirebaseFirestore.instance.collection('Users')
          .where('uid', isEqualTo: userdata['uid'])
          .get();
      print(updatedData.docs.first.data().toString());
      return right(updatedData.docs.first.data());
    }catch(e){
      return left('Data not found');
    }
  }
}
