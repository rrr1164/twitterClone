import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:twitterclone/core/utils/app_router.dart';
import 'package:twitterclone/cubit/home/home_state.dart';

import '../../core/assets.dart';
import '../../cubit/home/home_cubit.dart';
import '../../data/models/tweet.dart';
import '../../data/models/user_model.dart';
import '../../data/repo/user_repo.dart';
import '../../widgets/compose_tweet_dialog.dart';
import '../../widgets/edit_profile_dialog.dart';
import '../../widgets/single_tweet_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserRepo repo = UserRepo();

  String firebaseId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context
        .read<HomeCubit>()
        .fetchTweets(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is InitHomeState || state is LoadingHomeState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ResponseHomeState) {
          final tweets = state.tweets;
          return FutureBuilder(
              future: repo.getUserByFirebaseId(firebaseId),
              builder:
                  (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                if (snapshot.data != null && snapshot.hasData) {
                  return HomeWithAppBar(
                    user: snapshot.data!,
                    tweets: tweets,
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(' error: ${snapshot.error.toString()}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              });
        } else if (state is ErrorHomeState) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else {
          return Center(
            child: Text(state.toString()),
          );
        }
      },
    );
  }
}

class HomeWithAppBar extends StatefulWidget {
  const HomeWithAppBar({
    super.key,
    required this.user,
    required this.tweets,
  });

  final UserModel user;
  final List<Tweet> tweets;

  @override
  State<HomeWithAppBar> createState() => _HomeWithAppBarState();
}

class _HomeWithAppBarState extends State<HomeWithAppBar> {
  signOut() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      GoRouter.of(context).go(AppRouter.kLoginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ComposeTweetDialog();
                });
          },
          child: const Icon(Icons.create_outlined),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: () async {
            context
                .read<HomeCubit>()
                .fetchTweets(FirebaseAuth.instance.currentUser!.uid);
          },
          child: ListView.separated(
            itemBuilder: (context, index) {
              Tweet tweet = widget.tweets[index];
              return SingleTweet(tweet: tweet,isDetailsScreen: false,);
            },
            itemCount: widget.tweets.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                color: Colors.white,
              );
            },
          ),
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return EditProfileDialog(user: widget.user);
                    });
              },
              child: CachedNetworkImage(
                imageUrl: widget.user.photoUrl,
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.blue,
                ),
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundImage: image,
                ),
              )),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        shape: const Border(
            bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
        title: Image.asset(
          Assets.twitterLogo,
          width: 55,
        ),
        actions: [
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.blue,
            ),
          ),
        ],
      );
  }
}
