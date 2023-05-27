import '../../data/models/comment.dart';
import '../../data/models/tweet.dart';
import '../../data/models/user_model.dart';

abstract class TweetCommentsState {}

class TweetCommentsLoading extends TweetCommentsState {}

class TweetCommentsSuccess extends TweetCommentsState {
  List<Comment> comments;

  TweetCommentsSuccess({required this.comments});
}
class TweetCommentsError extends TweetCommentsState {}

class TweetCommentsInitial extends TweetCommentsState {}
