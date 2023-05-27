import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:twitterclone/core/assets.dart';
import 'package:twitterclone/core/utils/utilities.dart';
import 'package:twitterclone/cubit/signup/signup_cubit.dart';

import '../../core/utils/app_router.dart';
import '../../cubit/signup/signup_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RegisterBody();
  }
}

class RegisterBody extends StatefulWidget {
  const RegisterBody({Key? key}) : super(key: key);

  @override
  State<RegisterBody> createState() => RegisterBodyState();
}

class RegisterBodyState extends State<RegisterBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignUpCubit, SignUpState>(
        builder: (context, state) {
          if (state is! SignUpLoading) {
            return const InitialBody();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        listener: (context, state) {
          if (state is SignUpSuccess) {
            GoRouter.of(context).go(AppRouter.kVerifyScreen);
          } else if (state is SignUpFailure) {
            Utilities.showErrorSnackBar(context, "Error Signing up");
          }
        },
      ),
    );
  }
}

class InitialBody extends StatefulWidget {
  const InitialBody({
    super.key,
  });

  @override
  State<InitialBody> createState() => _InitialBodyState();
}

class _InitialBodyState extends State<InitialBody> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(width: 70.0),
                  Image.asset(Assets.twitterLogo, width: 65),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      child: const Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        GoRouter.of(context).go(AppRouter.kLoginScreen);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Sign Up To Twitter',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Email address',
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<SignUpCubit>(context).registerUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                          usernameController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // This is what you need!
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    ));
  }
}
