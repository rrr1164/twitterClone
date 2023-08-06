import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/utils/utilities.dart';
import '../models/comment.dart';
import '../models/tweet.dart';

class TweetsService {
  Future<List<Tweet>> getFollowedTweetsByFirebaseId(String firebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/get_following_tweets_by_firebase_id.php?firebase_id=$firebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("getting followed tweets by Firebase Uid request: $request");
    debugPrint(
        "getting followed tweets by Firebase Uid: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return await convertDynamicToTweets(
            jsonDecode(response.body) as List<dynamic>);
      } else {
        return [];
      }
    } else {
      throw "something went wrong ${response.statusCode}";
    }
  }

  Future<List<Tweet>> getUserTweetsByFirebaseId(
      String firebaseId, String askerFirebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/get_user_tweets.php?firebase_id=$firebaseId&asker_firebase_id=$askerFirebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("getting user tweets by Firebase Uid request: $request");
    debugPrint("getting user tweets by Firebase Uid: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return await convertDynamicToTweets(
            jsonDecode(response.body) as List<dynamic>);
      } else {
        return [];
      }
    } else {
      throw "something went wrong ${response.statusCode}";
    }
  }

  Future<List<Comment>> getCommentsByTweetId(int tweetId) async {
    String request =
        "${Utilities.baseApiUrl}/get_comments_by_tweet_id.php?tweet_id=$tweetId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("getting comments by tweet id request: $request");
    debugPrint("getting comments by tweet id Uid: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return convertDynamicToComments(
            jsonDecode(response.body) as List<dynamic>);
      } else {
        return [];
      }
    } else {
      throw "something went wrong ${response.statusCode}";
    }
  }

  Future<void> insertTweet(
    Tweet tweetToInsert,
    String firebaseId,
  ) async {
    String insertTweetRequest =
        "${Utilities.baseApiUrl}/insert_tweet.php?firebase_id=$firebaseId&tweet_content=${Uri.encodeComponent(tweetToInsert.getContent())}";
    http.Response insertTweetResponse =
        await http.get(Uri.parse(insertTweetRequest));
    debugPrint("inserting tweet by Firebase Uid request: $insertTweetRequest");
    debugPrint(
        "inserting tweet by Firebase Uid status code: ${insertTweetResponse.statusCode}");
    if (insertTweetResponse.statusCode != 201) {
      throw "something went wrong ${insertTweetResponse.statusCode}";
    }
    tweetToInsert.setId(int.parse(insertTweetResponse.body));
    try {
      insertTweetImages(tweetToInsert);
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> insertTweetImages(Tweet tweetToInsert) async {
    List<String> tweetImages = tweetToInsert.getImageUrls();
    if (tweetImages.isNotEmpty) {
      for (String tweetImage in tweetImages) {
        String insertTweetImageRequest =
            "${Utilities.baseApiUrl}/insert_tweet_image.php?url=${Uri.encodeComponent(tweetImage)}&tweet_id=${tweetToInsert.getId()}";
        http.Response insertTweetImageResponse =
            await http.get(Uri.parse(insertTweetImageRequest));
        debugPrint("inserting tweet image request: $insertTweetImageRequest");
        debugPrint(
            "inserting tweet image code: ${insertTweetImageResponse.statusCode}");
        if (insertTweetImageResponse.statusCode != 201) {
          throw "something went wrong ${insertTweetImageResponse.statusCode}";
        }
      }
    }
  }

  Future<void> deleteComment(int commentId) async {
    String request =
        "${Utilities.baseApiUrl}/delete_comment.php?comment_id=$commentId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("deleting comment request: $request");
    debugPrint("deleting comment status code: ${response.statusCode}");
    if (response.statusCode != 201) {
      throw "something went wrong ${response.statusCode}";
    }
  }

  Future<void> postComment(
      String comment, int tweetId, String firebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/add_comment.php?firebase_id=$firebaseId&comment=$comment&tweet_id=$tweetId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("posting comment request: $request");
    debugPrint("posting comment status code: ${response.statusCode}");
    if (response.statusCode != 201) {
      throw "something went wrong ${response.statusCode}";
    }
  }

  Future<void> likeTweet(int tweetId, String firebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/like_tweet.php?tweet_id=$tweetId&firebase_id=$firebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("liking tweet request: $request");
    debugPrint("liking tweet status code: ${response.statusCode}");
    if (response.statusCode != 201) {
      throw "something went wrong ${response.statusCode}";
    }
  }

  Future<void> unLikeTweet(int tweetId, String firebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/unlike_tweet.php?tweet_id=$tweetId&firebase_id=$firebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("unliking tweet request: $request");
    debugPrint("unliking tweet status code: ${response.statusCode}");
    if (response.statusCode != 201) {
      throw "something went wrong ${response.statusCode}";
    }
  }

  Future<List<Tweet>> convertDynamicToTweets(
      List<dynamic> dynamicTweets) async {
    List<Tweet> tweets = [];
    for (Map<String, dynamic> map in dynamicTweets) {
      if (map.isNotEmpty) {
        Tweet tweet = Tweet.fromJson(map);
        tweet.setImageUrls(await _getTweetImagesById(tweet.getId()));
        tweets.add(tweet);
      }
    }
    return tweets;
  }

  List<Comment> convertDynamicToComments(List<dynamic> dynamicComments) {
    List<Comment> comments = [];
    for (Map<String, dynamic> map in dynamicComments) {
      if (map.isNotEmpty) {
        Comment comment = Comment.fromJson(map);
        comments.add(comment);
      }
    }
    return comments;
  }

  Future<List<String>> _getTweetImagesById(int tweetId) async {
    String request =
        "${Utilities.baseApiUrl}/get_tweet_images.php?tweet_id=$tweetId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("getting tweet images request: $request");
    debugPrint("getting tweet images status code: ${response.statusCode}");
    List<String> imageUrls = [];
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        List<dynamic> dynamicImagesUrls = jsonDecode(response.body);
        for (Map<String, dynamic> map in dynamicImagesUrls) {
          if (map.isNotEmpty) {
            imageUrls.add(map["url"]);
          }
        }
      }
    }
    return imageUrls;
  }

  Future<List<Tweet>> searchTweets(String searchTerm, String firebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/search_tweets.php?search_term=${Uri.encodeComponent(searchTerm)}&firebase_id=$firebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("searching tweets by term request: $request");
    debugPrint("searching tweets by term status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return await convertDynamicToTweets(
            jsonDecode(response.body) as List<dynamic>);
      } else {
        return [];
      }
    } else {
      throw "error searching tweets by term ${response.statusCode}";
    }
  }
}
