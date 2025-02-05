import 'package:chatbudy/domain/usecases/is_logged_in_usecase.dart';
import 'package:chatbudy/presention/splash/bloc/splash_state.dart';
import 'package:chatbudy/servicelocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<SplashState>{

  SplashCubit() : super(DisplaySplash());

  void appStart() async {
    await Future.delayed( const Duration(seconds: 2));
    var isLoggedIn = await sl<IsLoggedInUseCase>().call();
    if(isLoggedIn){
      emit(
          Authenticated()
      );
    }else {
      emit(UnAuthenticated());
    }
  }
}