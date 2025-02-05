abstract class GptUseCase<Type,Params>{
  Future<String> call({Params params});
}