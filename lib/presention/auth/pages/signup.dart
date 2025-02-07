import 'package:chatbudy/comman/bloc/button/button_state.dart';
import 'package:chatbudy/comman/bloc/button/button_state_cubit.dart';
import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/comman/widgets/appbar/app_bar.dart';
import 'package:chatbudy/comman/widgets/button/basic_reactive_button.dart';
import 'package:chatbudy/core/theme/app_colors.dart';
import 'package:chatbudy/data/auth/models/user_creation_req.dart';
import 'package:chatbudy/domain/usecases/signup.dart';
import 'package:chatbudy/presention/auth/pages/signin.dart';
import 'package:chatbudy/presention/home/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final TextEditingController nameCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BasicAppbar(),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 40,
                ),
                child: BlocProvider(
                  create: (context) => ButtonStateCubit(),
                  child: BlocListener<ButtonStateCubit, ButtonStates>(
                    listener: (context, state) {
                      if (state is ButtonFailureState) {
                        var snackbar = SnackBar(
                          content: Text(state.errorMessage),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      } else if (state is ButtonSuccessState) {
                        AppNavigator.pushAndRemove(context, Home());
                        var snackbar = const SnackBar(
                          content: Text('SignIn Successful'),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _signUpText(context),
                        const SizedBox(height: 20),
                        _firstNameField(context),
                        const SizedBox(height: 20),
                        _emailField(context),
                        const SizedBox(height: 20),
                        _passwordField(context),
                        const SizedBox(height: 20),
                        _continueButton(context),
                        const SizedBox(height: 20),
                        _signUp(context),
                      ],
                    ),
                  ),

                ))));
  }

  Widget _signUpText(BuildContext context) {
    return const Text(
      "SignUp",
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _firstNameField(BuildContext context) {
    return TextField(
      controller: nameCon,
      decoration: const InputDecoration(
        hintText: "Name",
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: emailCon,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: passwordCon,
      decoration: const InputDecoration(
        hintText: "Password",
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return Container(
      height: 100,
      color: AppColors.secondBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Builder(
            builder: (context) {
              return BasicReactiveButton(
                  onPressed: (){
                    UserCreationReq userCreationReq = UserCreationReq(
                        name: nameCon.text,
                        email: emailCon.text,
                        password: passwordCon.text
                    );
                    context.read<ButtonStateCubit>().execute(
                      useCase: SignupUseCase(),
                      params: userCreationReq,
                    );
                  },
                  title: 'Finish'
              );
            }
        ),
      ),
    );
  }

  Widget _signUp(BuildContext context) {
    return Row(
      children: [
        const Text("Do have any account?. "),
        GestureDetector(
          onTap: () {
            AppNavigator.pushReplacement(context, SignIn());
          },
          child: const Text(
            "SignIn",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
