import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/domain/auth/entity/entity.dart';
import 'package:chatbudy/presention/about_us/page/about_us.dart';
import 'package:chatbudy/presention/auth/pages/signin.dart';
import 'package:chatbudy/presention/home/bloc/user_info_diaplay_state.dart';
import 'package:chatbudy/presention/home/bloc/user_info_display_cubit.dart';
import 'package:chatbudy/presention/user_profile/bloc/update_user_profile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserProfile extends StatefulWidget {
  final UserEntity user;
  UserProfile({required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();

}
class _UserProfileState extends State<UserProfile> {

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      
        body: Center(
          
          child: SingleChildScrollView(
            child: BlocBuilder<UserInfoDisplayCubit,UserInfoDisplayState>(
              builder: (context , user)
                {
                  if (user is UserInfoLoaded) {
            return
              Center(
                  child: Card(
                      color: Colors.white12,
                      elevation: 10,
                      child: Container(
                        padding: EdgeInsets.all(30),
                        height: height * 0.70,
                        width: width * 0.95,
                        child: Column(
                          children: [
                            _getProfileImage(user.userEntity),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            _changeImage(),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            _getUserName(context, user.userEntity),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            _getUserBio(user.userEntity),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            _getUserId(user.userEntity),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            _logOut(context),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            _aboutUs(),
                          ],
                        ),
                      )));
                  }else{
            return Center(child: CircularProgressIndicator(),);
                  }
              }
            ),
          ),
        ));
  }

  Widget _getProfileImage(UserEntity user) {
    print(user.profileImageUri.toString());
    return CircleAvatar(
      radius: 54,
      backgroundImage:
          (user.profileImageUri == null || user.profileImageUri.isEmpty)
              ? AssetImage("assets/images/default_user_profile_image.png") as ImageProvider
              : NetworkImage(user.profileImageUri) as ImageProvider,
    );
  }

  Widget _changeImage() {
    return TextButton(
        onPressed: () {},
        child: Text(
          'Change Profile Picture',
          style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),
        ));
  }

  Widget _getUserName(BuildContext context, UserEntity user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          user.name,
          style: TextStyle(fontSize: 24),
        ),
        ElevatedButton(
            onPressed: () {
              showEditProfileDialog(context, user);
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
            child: Icon(
              Icons.edit_outlined,
              color: Colors.white,
            ))
      ],
    );
  }

  Widget _getUserBio(UserEntity user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          user.bio ?? user.name ,
          style: TextStyle(fontSize: 24),
        ),
      ],
    );
  }

  Widget _getUserId(UserEntity user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(user.email, style: TextStyle(fontSize: 20)),
      ],
    );
  }

  Widget _logOut(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              AppNavigator.pushAndRemove(context, SignIn());
            },
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.transparent)),
            child: Text(
              'LogOut',
              style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),
            )),
      ],
    );
  }

  Widget _aboutUs() {
    return InkWell(
      onTap: (){
        AppNavigator.push(context, AboutUs());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'About Us',
            style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),
          ),
        ],
      ),
    );
  }

  void showEditProfileDialog(BuildContext context, UserEntity user) {
    String username = user.name;
    String bio = user.bio;
    String uid = user.uid;
    TextEditingController usernameController =
        TextEditingController(text: username);
    TextEditingController bioController = TextEditingController(text: bio);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "Username"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: bioController,
                decoration: InputDecoration(labelText: "Bio"),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, String> updatedData = {
                  'username': usernameController.text.trim(),
                  'bio': bioController.text.trim(),
                  'uid': user.uid,
                };
                BlocProvider.of<UpdateUserProfileCubit>(context).updateUserProfile(updatedData);
                  Navigator.of(context).pop(); // Close the dialog

              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  String username = "JohnDoe";

  String bio = "Flutter Developer 🚀";
}
