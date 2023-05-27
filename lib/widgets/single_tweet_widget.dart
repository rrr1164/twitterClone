import 'package:cached_network_image/cached_network_image.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twitterclone/data/repo/tweets_repo.dart';
import 'package:twitterclone/screens/misc/hashtag_details_screen.dart';
import 'package:twitterclone/screens/misc/tweet_details_screen.dart';
import 'package:twitterclone/screens/misc/user_details_screen.dart';

import '../cubit/tweet_comments/tweet_comments_cubit.dart';
import '../data/models/tweet.dart';
import 'compose_comment_dialog.dart';

class SingleTweet extends StatefulWidget {
  SingleTweet({
    super.key,
    required this.tweet,
    required this.isDetailsScreen,
  });

  final Tweet tweet;
  final TweetsRepository tweetsRepository = TweetsRepository();
  final bool isDetailsScreen;

  @override
  State<SingleTweet> createState() => _SingleTweetState();
}

class _SingleTweetState extends State<SingleTweet> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!widget.isDetailsScreen) {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      TweetDetailsScreen(tweet: widget.tweet)))
              .then((value) {
            setState(() {});
          });
        }
      },
      child: Column(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            UserDetailsScreen(user: widget.tweet.poster)));
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.tweet.poster.photoUrl,
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
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 5),
                      child: Text(
                        widget.tweet.poster.userName,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 5),
                      child: DetectableText(
                        text: widget.tweet.content,
                        detectionRegExp:
                            detectionRegExp(atSign: false, url: false)!,
                        onTap: (tappedText) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HashTagDetailsScreen(
                                    hashtag: tappedText,
                                  )));
                        },
                        detectedStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.blue,
                        ),
                        basicStyle: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.tweet.imageUrl != null) ...[
                      CachedNetworkImage(
                        imageUrl: widget.tweet.imageUrl!,
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, left: 10),
                      child: Row(
                        children: <Widget>[
                          buildCommentsButton(context),
                          buildLikesButton(),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }

  Padding buildLikesButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: GestureDetector(
        onTap: () async {
          if (widget.tweet.isLiked && widget.tweet.likes <= 0) return;
          bool oldLikedStatus = widget.tweet.isLiked;
          setState(() {
            if (widget.tweet.isLiked) {
              widget.tweet.likes--;
            } else {
              widget.tweet.likes++;
            }
            widget.tweet.isLiked = !widget.tweet.isLiked;
          });
          if (oldLikedStatus) {
            if (widget.tweet.likes >= 0) {
              await widget.tweetsRepository.unLikeTweet(
                  widget.tweet.id, FirebaseAuth.instance.currentUser!.uid);
            }
          } else {
            await widget.tweetsRepository.likeTweet(
                widget.tweet.id, FirebaseAuth.instance.currentUser!.uid);
          }
        },
        child: Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                  child: Container(
                      padding: const EdgeInsets.only(right: 8),
                      child: widget.tweet.isLiked
                          ? const Icon(FontAwesomeIcons.solidHeart,
                              color: Colors.red)
                          : const Icon(FontAwesomeIcons.heart))),
              TextSpan(
                  text: '${widget.tweet.likes}',
                  style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildCommentsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return ComposeCommentDialog(tweet: widget.tweet);
            }).then((added) {
          if (added) {
            setState(() {
              widget.tweet.commentsCount++;
            });
            context.read<TweetCommentsCubit>().fetchComments(widget.tweet.id);
          }
        });
      },
      child: Text.rich(
        TextSpan(
          children: [
            WidgetSpan(
                child: Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: const Icon(FontAwesomeIcons.comment))),
            TextSpan(
                text: '${widget.tweet.commentsCount}',
                style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
