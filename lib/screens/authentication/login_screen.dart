import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:twitterclone/core/assets.dart';
import 'package:twitterclone/cubit/login/login_cubit.dart';

import '../../core/utils/app_router.dart';
import '../../core/utils/utilities.dart';
import '../../cubit/login/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LoginBody();
  }
}

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state is! LoginLoading) {
            return const InitialLogin();
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        listener: (context, state) {
          if (state is LoginSuccess) {
            if (FirebaseAuth.instance.currentUser != null &&
                !FirebaseAuth.instance.currentUser!.emailVerified) {
              GoRouter.of(context).go(AppRouter.kVerifyScreen);
            } else {
              GoRouter.of(context).go(AppRouter.kScreensNavigator);
            }
          } else if (state is LoginFailure) {
            Utilities.showErrorSnackBar(context, "Error Logging in");
          }
        },
      ),
    );
  }
}

class InitialLogin extends StatefulWidget {
  const InitialLogin({
    super.key,
  });

  @override
  State<InitialLogin> createState() => _InitialLoginState();
}

class _InitialLoginState extends State<InitialLogin> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
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
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        GoRouter.of(context).go(AppRouter.kRegisterScreen);
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                'Login to Twitter',
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
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: 50,
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<LoginCubit>(context).logInUser(
                          emailController.text.trim(),
                          passwordController.text.trim());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // This is what you need!
                    ),
                    child: const Text(
                      'Login',
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
