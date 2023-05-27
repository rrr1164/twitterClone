import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/core/assets.dart';
import 'package:twitterclone/cubit/tweet_comments/tweet_comments_cubit.dart';
import 'package:twitterclone/cubit/tweet_comments/tweet_comments_state.dart';
import 'package:twitterclone/widgets/single_comment_widget.dart';
import 'package:twitterclone/widgets/single_tweet_widget.dart';

import '../../data/models/comment.dart';
import '../../data/models/tweet.dart';
import '../../widgets/appBar_widget.dart';

class TweetDetailsScreen extends StatefulWidget {
  const TweetDetailsScreen({Key? key, required this.tweet}) : super(key: key);
  final Tweet tweet;

  @override
  State<TweetDetailsScreen> createState() => _TweetDetailsState();
}

class _TweetDetailsState extends State<TweetDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TweetCommentsCubit>().fetchComments(widget.tweet.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return context
                .read<TweetCommentsCubit>()
                .fetchComments(widget.tweet.id);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleTweet(
                  tweet: widget.tweet,
                  isDetailsScreen: true,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 32.0, left: 16),
                  child: Text(
                    "Comments",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                BlocBuilder<TweetCommentsCubit, TweetCommentsState>(
                  builder: (context, state) {
                    if (state is TweetCommentsInitial) {
                      return Container();
                    }
                    if (state is TweetCommentsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is TweetCommentsError) {
                      return const Center(
                        child: Text("Error getting comments"),
                      );
                    } else {
                      TweetCommentsSuccess currentState =
                          state as TweetCommentsSuccess;
                      List<Comment> comments = currentState.comments;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Comment comment = comments[index];
                          return SingleComment(
                            comment: comment,
                            tweet: widget.tweet,
                          );

                        },
                        itemCount: comments.length,
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
      appBar: const CustomAppBar(),
    );
  }


}
