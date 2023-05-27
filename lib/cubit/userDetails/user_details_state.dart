import '../../data/models/tweet.dart';

abstract class UserDetailsState {}

class InitUserDetailsState extends UserDetailsState{}
class LoadingUserDetailsState extends UserDetailsState{}
class ErrorUserDetailsState extends UserDetailsState{
  String errorMessage;
  ErrorUserDetailsState(this.errorMessage);
}
class ResponseUserDetailsState extends UserDetailsState{
  List<Tweet> tweets;
  ResponseUserDetailsState(this.tweets);
}