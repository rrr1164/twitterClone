import '../../data/models/tweet.dart';
import '../../data/models/user_model.dart';

abstract class SearchState {}

class SearchLoading extends SearchState {}

class SearchUsersSuccess extends SearchState {
  List<UserModel> users;

  SearchUsersSuccess({required this.users});
}
class SearchTweetsSuccess extends SearchState {
  List<Tweet> tweets;

  SearchTweetsSuccess({required this.tweets});
}
class SearchFailure extends SearchState {
  String errorMessage;

  SearchFailure({required this.errorMessage});
}

class SearchInitial extends SearchState {}
