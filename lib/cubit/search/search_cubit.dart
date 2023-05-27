import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/cubit/search/search_state.dart';
import 'package:twitterclone/data/repo/tweets_repo.dart';
import 'package:twitterclone/data/repo/user_repo.dart';

import '../../data/models/tweet.dart';
import '../../data/models/user_model.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  UserRepo userRepo = UserRepo();
  TweetsRepository tweetsRepository = TweetsRepository();
  String lastSearch = "";
  String dropDownValue = '@';
  Future<void> searchTweets(String searchTerm) async {
    emit(SearchLoading());
    try {
      List<Tweet> tweets = await tweetsRepository.searchTweets(searchTerm,FirebaseAuth.instance.currentUser!.uid);
      emit(SearchTweetsSuccess(tweets: tweets));
    } catch (error) {
      debugPrint("error searching $error");
      emit(SearchFailure(errorMessage: '$error'));
    }
    lastSearch = searchTerm;
  }
  Future<void> searchUsers(String searchTerm) async {
    emit(SearchLoading());
    try {
      List<UserModel> users = await userRepo.searchUsers(searchTerm,FirebaseAuth.instance.currentUser!.uid);
      emit(SearchUsersSuccess(users: users));
    } catch (error) {
      emit(SearchFailure(errorMessage: '$error'));
    }
    lastSearch = searchTerm;
  }
}
