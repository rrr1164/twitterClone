import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitterclone/cubit/bottomNavigation/bottom_navigation_cubit.dart';
import 'package:twitterclone/cubit/home/home_cubit.dart';
import 'package:twitterclone/cubit/login/login_cubit.dart';
import 'package:twitterclone/cubit/search/search_cubit.dart';
import 'package:twitterclone/cubit/signup/signup_cubit.dart';
import 'package:twitterclone/cubit/tweet_comments/tweet_comments_cubit.dart';
import 'package:twitterclone/cubit/userDetails/user_details_cubit.dart';

import 'core/utils/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => BottomNavigationCubit()),
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => TweetCommentsCubit()),
        BlocProvider(create: (context) => UserDetailsCubit()),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            brightness: Brightness.light,
            fontFamily: GoogleFonts.poppins().fontFamily),
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
