import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/core/theme/app_colors.dart';
import 'package:chatbudy/domain/auth/entity/entity.dart';
import 'package:chatbudy/presention/home/bloc/user_info_diaplay_state.dart';
import 'package:chatbudy/presention/home/bloc/user_info_display_cubit.dart';
import 'package:chatbudy/presention/user_profile/bloc/update_user_profile_cubit.dart';
import 'package:chatbudy/presention/user_profile/page/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Header extends StatelessWidget {
   Header({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoDisplayCubit()..displayUserInfo(),
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 16, left: 16),
        child: BlocBuilder<UserInfoDisplayCubit, UserInfoDisplayState>(
          builder: (context, state) {
            if (state is UserInfoLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserInfoLoaded) {
              return Row(

                children: [
                  _profileImage(context,state.userEntity),
                  SizedBox(width: 25),
                  _userName(state.userEntity.name),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _profileImage(BuildContext context,UserEntity user) {
    return BlocProvider(
      create: (context) => UserInfoDisplayCubit(),
      child: GestureDetector(
        onTap: (){
          AppNavigator.push(context,  BlocProvider(create: (context) => UserInfoDisplayCubit()..displayUserInfo(),child: UserProfile(user: user))) ;
        },
        child: CircleAvatar(
          radius: 20,
            backgroundImage: (user.profileImageUri == null ||
                user.profileImageUri.isEmpty)
                ? AssetImage("assets/images/default_user_profile_image.png") as ImageProvider
                : NetworkImage(user.profileImageUri) as ImageProvider,),
      ),
    );
  }

  Widget _userName(String name) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(100)),
      child: Center(
        child: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }
}
