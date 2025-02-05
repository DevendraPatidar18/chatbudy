import 'package:chatbudy/comman/bloc/button/button_state.dart';
import 'package:chatbudy/comman/bloc/button/button_state_cubit.dart';
import 'package:chatbudy/comman/helper/navigator/app_navigator.dart';
import 'package:chatbudy/comman/widgets/appbar/app_bar.dart';
import 'package:chatbudy/comman/widgets/button/basic_reactive_button.dart';
import 'package:chatbudy/data/auth/models/user_signin_req.dart';
import 'package:chatbudy/domain/usecases/signin.dart';
import 'package:chatbudy/presention/auth/pages/signup.dart';
import 'package:chatbudy/presention/home/page/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(
        hideBack: true,
      ),
      body: Padding(
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
                _signinText(context),
                const SizedBox(height: 20),
                _emailField(context),
                const SizedBox(height: 20),
                _passwordField(context),
                const SizedBox(height: 20),
                _continueButton(context),
                const SizedBox(height: 20),
                _createAccount(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signinText(BuildContext context) {
    return const Text(
      "SignIn",
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
    return Builder(

        builder: (context) {
          return BasicReactiveButton(
            onPressed: () {
              if(emailCon.text.isNotEmpty && passwordCon.text.isNotEmpty) {
                UserSignInReq userData =
                UserSignInReq(
                    email: emailCon.text.trim().toLowerCase(),
                    password: passwordCon.text.trim().toLowerCase());
                context.read<ButtonStateCubit>().execute(
                    useCase: SignInUseCase(),
                    params: userData
                );
              }else{
                throw Error();
              }
            },
            title: 'Continue',
          );

        }
    );
    /*return BasicReactiveButton(onPressed: () {
      UserSignInReq userData =
          UserSignInReq(email: emailCon.text, password: passwordCon.text);
      context
          .read<ButtonStateCubit>()
          .execute(useCase: SignInUseCase(), params: userData);
    });*/
  }

  Widget _createAccount(BuildContext context) {
    return Row(
      children: [
        const Text("don't have any account?. "),
        GestureDetector(
          onTap: () {
            AppNavigator.push(context, SignUp());
          },
          child: const Text(
            "Create Account",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
