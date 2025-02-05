import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/core/theme/app_colors.dart';
import 'package:chatbudy/presention/auth/pages/signin.dart';
import 'package:chatbudy/presention/home/page/home.dart';
import 'package:chatbudy/presention/splash/bloc/splash_cubit.dart';
import 'package:chatbudy/presention/splash/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit,SplashState>(
      listener: (context,state){
        if(state is UnAuthenticated){
          AppNavigator.pushReplacement(context, SignIn());
        }
        if(state is Authenticated){
          AppNavigator.pushReplacement(context, const Home());
        }
      },
      child:  Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Image.asset('assets/images/app_logo.png',scale: 7.5),
        ),
      ),
    );
  }
}
