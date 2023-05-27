import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/cubit/tweet_comments/tweet_comments_state.dart';
import 'package:twitterclone/data/repo/tweets_repo.dart';

import '../../data/models/comment.dart';

class TweetCommentsCubit extends Cubit<TweetCommentsState> {
  TweetCommentsCubit() : super(TweetCommentsInitial());
  TweetsRepository tweetsRepository = TweetsRepository();

  Future<void> fetchComments(int tweetId) async {
    emit(TweetCommentsLoading());
    try {
      List<Comment> comments =
          await tweetsRepository.getCommentsByTweetId(tweetId);
      emit(TweetCommentsSuccess(comments: comments));
    } catch (error) {
      debugPrint("error searching $error");
      emit(TweetCommentsError());
    }
  }
}
