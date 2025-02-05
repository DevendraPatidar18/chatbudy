abstract class ButtonStates{}

class ButtonInitializeState extends ButtonStates{}

class ButtonLoadingState extends ButtonStates{}

class ButtonSuccessState extends ButtonStates{}

class ButtonFailureState extends ButtonStates {
  final String errorMessage;
  ButtonFailureState({required this.errorMessage});
}