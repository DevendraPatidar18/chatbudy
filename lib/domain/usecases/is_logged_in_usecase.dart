import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/domain/auth/repository/auth.dart';
import 'package:chatbudy/servicelocator.dart';


class IsLoggedInUseCase implements UseCase<bool,dynamic>{
  @override
  Future<bool> call({params}) async {
   return await sl<AuthRepository>().isLoggedIn();
  }


}