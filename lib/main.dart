import 'dart:io';

import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/core/theme/app_theme.dart';
import 'package:chatbudy/firebase_options.dart';
import 'package:chatbudy/presention/home/bloc/user_info_display_cubit.dart';
import 'package:chatbudy/presention/splash/bloc/splash_cubit.dart';
import 'package:chatbudy/presention/splash/page/splash.dart';
import 'package:chatbudy/presention/user_profile/bloc/update_user_profile_cubit.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var uuid = Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDependencies();
  runApp(const MyApp());

}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserInfoDisplayCubit()..displayUserInfo()),
        BlocProvider(create: (context) => UpdateUserProfileCubit()),
       BlocProvider(
        create: (context) => SplashCubit()..appStart()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.appTheme,
            home:  const SplashPage()
            ),
      );

  }
}
