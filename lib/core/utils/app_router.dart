import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:twitterclone/screens/authentication/verify_screen.dart';
import 'package:twitterclone/screens/misc/tweet_details_screen.dart';

import '../../screens/authentication/register_screen.dart';
import '../../screens/misc/initial_router_screen.dart';
import '../../screens/authentication/login_screen.dart';
import '../../screens/main/screens_navigator.dart';

abstract class AppRouter {
  static const String kLoginScreen = '/login';
  static const String kRegisterScreen = '/register';
  static const String kVerifyScreen = '/verifyemail';
  static const String kScreensNavigator = '/screensNavigator';

  static final GoRouter router = GoRouter(routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const InitialRouterScreen();
      },
    ),
    GoRoute(
      path: kScreensNavigator,
      builder: (BuildContext context, GoRouterState state) {
        return const ScreensNavigator();
      },
    ),
    GoRoute(
      path: kLoginScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: kRegisterScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: kVerifyScreen,
      builder: (BuildContext context, GoRouterState state) {
        return const VerifyScreen();
      },
    ),
  ]);
}
