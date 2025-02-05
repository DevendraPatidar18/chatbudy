import 'package:chatbudy/core/usecase/GetMessagesUseCase.dart';
import 'package:chatbudy/core/usecase/usecase.dart';
import 'package:chatbudy/data/auth/repository/auth_repository_imp.dart';
import 'package:chatbudy/data/auth/source/auth_firebase_service.dart';
import 'package:chatbudy/domain/auth/repository/auth.dart';

import 'package:chatbudy/domain/chat/repository/chat_room_repo.dart';
import 'package:chatbudy/domain/usecases/chat_room_usecase.dart';
import 'package:chatbudy/domain/usecases/get_chatgpt_response_usecase.dart';
import 'package:chatbudy/domain/usecases/get_message_usecase.dart';
import 'package:chatbudy/domain/usecases/get_recent_chat_usecase.dart';
import 'package:chatbudy/domain/usecases/get_user.dart';
import 'package:chatbudy/domain/usecases/is_logged_in_usecase.dart';
import 'package:chatbudy/domain/usecases/search.dart';
import 'package:chatbudy/domain/usecases/send_message_usecase.dart';
import 'package:chatbudy/domain/usecases/signin.dart';
import 'package:chatbudy/domain/usecases/signup.dart';
import 'package:chatbudy/domain/usecases/update_user_profile_usecase.dart';
import 'package:get_it/get_it.dart';

import 'core/usecase/get_recent_chat_usecase.dart';
import 'core/usecase/user_usecase.dart';
import 'data/search_chat/repository/chat_room_repository._imp.dart';
import 'data/search_chat/source/chat_room_service.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  //Services
  sl.registerSingleton<AuthFirebaseService>(
      AuthFirebaseServiceImp()
  );
  sl.registerSingleton<ChatRoomService>(
    ChatRoomServiceImp()
  );

  //Repository
  sl.registerSingleton<AuthRepository>(
      AuthRepositoryImp()
  );
  sl.registerSingleton<ChatRoomRepo>(
    ChatRoomRepositoryImp()
  );

  //UseCase

  sl.registerSingleton<SignupUseCase>(
      SignupUseCase()
  );
  sl.registerSingleton<SignInUseCase>(
      SignInUseCase()
  );
  sl.registerSingleton<IsLoggedInUseCase>(
      IsLoggedInUseCase()
  );
  sl.registerSingleton<GetUserUseCaseimp>(
      GetUserUseCaseimp()
  );
  sl.registerSingleton<GetFirebaseUsersUseCase>(
      GetFirebaseUsersUseCase()
  );
  sl.registerSingleton<ChatRoomUseCase>(
    ChatRoomUseCase()
  );
  sl.registerSingleton<SendMessageUseCase>(
    SendMessageUseCase()
  );
  sl.registerSingleton<GetMessageUseCase>(
      GetMessageUseCaseImpl()
  );
  sl.registerSingleton<GetRecentChatUseCaseImp>(
      GetRecentChatUseCaseImp()
  );
  sl.registerSingleton<GetChatGptResponseUseCase>(
      GetChatGptResponseUseCase()
  );
  sl.registerSingleton<UpdateUserProfileUseCase>(
    UpdateUserProfileUseCase()
  );


}
