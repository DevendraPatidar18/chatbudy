abstract class MessageUseCase<Type,Params, Params1>{
  Future<Type> call({Params params,Params1 params1});
}