import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitterclone/data/models/comment.dart';
import 'package:twitterclone/data/repo/tweets_repo.dart';

import '../cubit/tweet_comments/tweet_comments_cubit.dart';
import '../data/models/tweet.dart';

class SingleComment extends StatefulWidget {
  SingleComment({
    super.key,
    required this.comment,
    required this.tweet,
  });

  final Comment comment;
  final Tweet tweet;
  final TweetsRepository tweetsRepository = TweetsRepository();

  @override
  State<SingleComment> createState() => _SingleCommentState();
}

class _SingleCommentState extends State<SingleComment> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                imageUrl: widget.comment.poster.photoUrl,
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 25,
                ),
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundImage: image,
                  radius: 25,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 5),
                    child: Text(
                      widget.comment.poster.userName,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 5),
                    child: Text(
                      widget.comment.content,
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            if (FirebaseAuth.instance.currentUser!.uid ==
                widget.comment.poster.firebaseId)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                    onPressed: () async {
                      widget.tweet.commentsCount--;
                      await widget.tweetsRepository
                          .deleteComment(widget.comment.id);
                      if (context.mounted) {
                        context
                            .read<TweetCommentsCubit>()
                            .fetchComments(widget.tweet.id);
                      }
                    },
                    icon: const Icon(Icons.delete)),
              ),
          ],
        ),
      )
    ]);
  }
}
