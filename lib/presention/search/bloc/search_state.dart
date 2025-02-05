import 'package:chatbudy/domain/auth/entity/entity.dart';

abstract class SearchState{}
 class SearchStateLoading extends SearchState{}
class SearchStateLoadedSuccessfull extends SearchState{
  final UserEntity userEntity;

   SearchStateLoadedSuccessfull({
    required this.userEntity,
  });
}
class SearchStateFailed extends SearchState{
  final String errorMessage;

  SearchStateFailed({
    required this.errorMessage,
  });
}
class SearchByUidStateIsLoadedSuccessfully extends SearchState{
  final UserEntity userEntity;

  SearchByUidStateIsLoadedSuccessfully({
    required this.userEntity,
  });
}
