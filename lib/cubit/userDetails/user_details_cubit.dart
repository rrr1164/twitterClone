import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/cubit/userDetails/user_details_state.dart';
import 'package:twitterclone/data/repo/tweets_repo.dart';

import '../../data/models/tweet.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final TweetsRepository _repository = TweetsRepository();
  List<Tweet> tweets = [];

  UserDetailsCubit() : super(InitUserDetailsState());

  Future<void> fetchTweets(String firebaseId,String askerFirebaseId) async {
    emit(LoadingUserDetailsState());
    try {
      final response = await _repository.getUserTweetsByFirebaseId(firebaseId,askerFirebaseId);
      tweets = response;
      emit(ResponseUserDetailsState(response));
    } catch (e) {
      emit(ErrorUserDetailsState(e.toString()));
    }
  }
}
