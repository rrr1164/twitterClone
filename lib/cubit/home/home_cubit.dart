import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/cubit/home/home_state.dart';
import 'package:twitterclone/data/repo/tweets_repo.dart';

import '../../data/models/tweet.dart';

class HomeCubit extends Cubit<HomeState> {
  final TweetsRepository _repository = TweetsRepository();
  List<Tweet> tweets = [];

  HomeCubit() : super(InitHomeState());

  Future<void> fetchTweets(String firebaseId) async {
    emit(LoadingHomeState());
    try {
      final response = await _repository.getFollowedTweetsByFirebaseId(firebaseId);
      tweets = response;
      emit(ResponseHomeState(response));
    } catch (e) {
      emit(ErrorHomeState(e.toString()));
    }
  }
}
