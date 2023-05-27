import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/cubit/userDetails/user_details_cubit.dart';
import 'package:twitterclone/cubit/userDetails/user_details_state.dart';
import 'package:twitterclone/data/repo/user_repo.dart';
import 'package:twitterclone/widgets/appBar_widget.dart';
import 'package:twitterclone/widgets/single_tweet_widget.dart';

import '../../data/models/tweet.dart';
import '../../data/models/user_model.dart';
import '../../widgets/followButton.dart';

class UserDetailsScreen extends StatefulWidget {
  UserDetailsScreen({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  UserRepo userRepo = UserRepo();

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<UserDetailsCubit>().fetchTweets(widget.user.firebaseId,FirebaseAuth.instance.currentUser!.uid);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Avatar(widget: widget),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.user.userName,
                style: const TextStyle(fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              if (widget.user.firebaseId !=
                  FirebaseAuth.instance.currentUser!.uid)
                FollowButtonWidget(user: widget.user),
              const TweetsTitle(),
              BlocBuilder<UserDetailsCubit, UserDetailsState>(
                builder: (context, state) {
                  if (state is InitUserDetailsState ||
                      state is LoadingUserDetailsState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ResponseUserDetailsState) {
                    final tweets = state.tweets;
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Tweet tweet = tweets[index];
                        return SingleTweet(
                          tweet: tweet,
                          isDetailsScreen: false,
                        );
                      },
                      itemCount: tweets.length,
                    );
                  } else if (state is ErrorUserDetailsState) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  } else {
                    return Center(
                      child: Text(state.toString()),
                    );
                  }
                },
              )
            ],
          ),
        )),
      ),
      appBar: const CustomAppBar(),
    );
  }
}

class TweetsTitle extends StatelessWidget {
  const TweetsTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.only(top:32.0,left:32),
          child: Text(
            "Tweets",
            style: TextStyle(fontSize: 24),
          ),
        ));
  }
}

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.widget,
  });

  final UserDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: CachedNetworkImage(
        imageUrl: widget.user.photoUrl,
        placeholder: (context, url) => const CircleAvatar(
          backgroundColor: Colors.blue,
        ),
        imageBuilder: (context, image) => CircleAvatar(
          backgroundImage: image,
        ),
      ),
    );
  }
}
