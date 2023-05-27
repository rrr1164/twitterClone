import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/app_router.dart';

class InitialRouterScreen extends StatefulWidget {
  const InitialRouterScreen({Key? key}) : super(key: key);

  @override
  State<InitialRouterScreen> createState() => _InitialRouterScreenState();
}

class _InitialRouterScreenState extends State<InitialRouterScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Firebase.initializeApp().then((value) {
        routeUser();
      });
    });
  }

  Future<void> routeUser() async {
    if (FirebaseAuth.instance.currentUser != null &&
        FirebaseAuth.instance.currentUser!.emailVerified) {
      GoRouter.of(context).go(AppRouter.kScreensNavigator);
    } else {
      GoRouter.of(context).go(AppRouter.kRegisterScreen);
    }
  }
}
