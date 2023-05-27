import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/data/repo/tweets_repo.dart';
import 'package:twitterclone/widgets/appBar_widget.dart';

import '../../data/models/tweet.dart';
import '../../widgets/single_tweet_widget.dart';

class HashTagDetailsScreen extends StatefulWidget {
  HashTagDetailsScreen({Key? key, required this.hashtag}) : super(key: key);
  final String hashtag;
  TweetsRepository tweetsRepository = TweetsRepository();

  @override
  State<HashTagDetailsScreen> createState() => _HashTagDetailsScreenState();
}

class _HashTagDetailsScreenState extends State<HashTagDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          Text(widget.hashtag,style: const TextStyle(fontSize: 32),),
          Expanded(
            child: FutureBuilder(
                future: widget.tweetsRepository.searchTweets(
                    widget.hashtag, FirebaseAuth.instance.currentUser!.uid),
                builder: (BuildContext context, AsyncSnapshot<List<Tweet>> snapshot) {
                  if (snapshot.data != null && snapshot.hasData) {
                    List<Tweet> tweets = snapshot.data!;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Tweet tweet = tweets[index];
                        return SingleTweet(
                          tweet: tweet,
                          isDetailsScreen: false,
                        );
                      },
                      itemCount: tweets.length,
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(' error: ${snapshot.error.toString()}'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ],
      ),
    );
  }
}
