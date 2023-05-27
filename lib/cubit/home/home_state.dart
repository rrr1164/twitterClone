import '../../data/models/tweet.dart';

abstract class HomeState {}

class InitHomeState extends HomeState{}
class LoadingHomeState extends HomeState{}
class ErrorHomeState extends HomeState{
  String errorMessage;
  ErrorHomeState(this.errorMessage);
}
class ResponseHomeState extends HomeState{
  List<Tweet> tweets;
  ResponseHomeState(this.tweets);
}