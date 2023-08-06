import 'package:twitterclone/data/services/tweets_service.dart';

import '../models/comment.dart';
import '../models/tweet.dart';

class TweetsRepository {
  TweetsService service = TweetsService();

  Future<List<Tweet>> getFollowedTweetsByFirebaseId(String firebaseId) async {
    try{
      return await service.getFollowedTweetsByFirebaseId(firebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }
  Future<List<Tweet>> getUserTweetsByFirebaseId(String firebaseId,String askerFirebaseId) async {
    try{
      return await service.getUserTweetsByFirebaseId(firebaseId,askerFirebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }

  Future<List<Comment>> getCommentsByTweetId(int tweetId) async {
    try{
      return await service.getCommentsByTweetId(tweetId);
    }
    catch(error){
      throw error.toString();
    }
  }

  Future<void> deleteComment(int commentId) async {
    try{
      return await service.deleteComment(commentId);
    }
    catch(error){
      throw error.toString();
    }
  }

  Future<void> postComment(
      String comment, int tweetId, String firebaseId) async {
    try{
      return await service.postComment(comment,tweetId,firebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }

  Future<void> likeTweet(int tweetId, String firebaseId) async {
    try{
      return await service.likeTweet(tweetId,firebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }

  Future<void> unLikeTweet(int tweetId, String firebaseId) async {
    try{
      return await service.unLikeTweet(tweetId,firebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }

  Future<void> insertTweet(Tweet tweetToInsert, String firebaseId) async {
    try{
      return await service.insertTweet(tweetToInsert,firebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }
  Future<List<Tweet>> searchTweets(String searchTerm, String firebaseId) async {
    try{
      return await service.searchTweets(searchTerm,firebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }
}
