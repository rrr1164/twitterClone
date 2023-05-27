import 'package:twitterclone/data/services/tweets_service.dart';

import '../models/comment.dart';
import '../models/tweet.dart';

class TweetsRepository {
  TweetsService service = TweetsService();

  Future<List<Tweet>> getFollowedTweetsByFirebaseId(String firebaseId) async {
    return await service.getFollowedTweetsByFirebaseId(firebaseId);
  }
  Future<List<Tweet>> getUserTweetsByFirebaseId(String firebaseId,String askerFirebaseId) async {
    return await service.getUserTweetsByFirebaseId(firebaseId,askerFirebaseId);
  }

  Future<List<Comment>> getCommentsByTweetId(int tweetId) async {
    return await service.getCommentsByTweetId(tweetId);
  }

  Future<void> deleteComment(int commentId) async {
    return await service.deleteComment(commentId);
  }

  Future<void> postComment(
      String comment, int tweetId, String firebaseId) async {
    return await service.postComment(comment, tweetId, firebaseId);
  }

  Future<void> likeTweet(int tweetId, String firebaseId) async {
    return await service.likeTweet(tweetId, firebaseId);
  }

  Future<void> unLikeTweet(int tweetId, String firebaseId) async {
    return await service.unLikeTweet(tweetId, firebaseId);
  }

  Future<void> insertTweet(Tweet tweetToInsert, String firebaseId) async {
    return service.insertTweet(tweetToInsert, firebaseId);
  }

  Future<List<Tweet>> searchTweets(String searchTerm, String firebaseId) async {
    return service.searchTweets(searchTerm, firebaseId);
  }
}
