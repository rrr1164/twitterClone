import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/widgets/single_tweet_widget.dart';

import '../../cubit/search/search_cubit.dart';
import '../../cubit/search/search_state.dart';
import '../../data/models/tweet.dart';
import '../../data/models/user_model.dart';
import '../../widgets/single_user_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  late SearchCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = context.read<SearchCubit>();
    searchController = TextEditingController(text: cubit.lastSearch);
    if (cubit.lastSearch.isNotEmpty) {
      if (cubit.dropDownValue == '@') {
        cubit.searchUsers(cubit.lastSearch);
      } else {
        cubit.searchTweets(cubit.lastSearch);
      }
    }
  }

  // List of items in our dropdown menu
  var items = ['@', '📝'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
      child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: SizedBox(
                        height: 65,
                        width: 60,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<String>(
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            value: cubit.dropDownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                cubit.dropDownValue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          labelText: 'Search',
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                callCubit();
                              }),
                        ),
                      ),
                    ),
                  ],
                ),
                BlocBuilder<SearchCubit, SearchState>(builder: (context, state) {
                  if (state is SearchInitial) {
                    return Container();
                  }
                  if (state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchFailure) {
                    return Center(
                      child: Text("Error searching ${state.errorMessage}"),
                    );
                  } else if (state is SearchUsersSuccess) {
                    List<UserModel> users = state.users;
                    return RefreshIndicator(
                      onRefresh: () async {
                        callCubit();
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          UserModel user = users[index];
                          return SingleUserWidget(
                            user: user,
                          );
                        },
                        itemCount: users.length,
                      ),
                    );
                  } else {
                    SearchTweetsSuccess currentState =
                        state as SearchTweetsSuccess;
                    List<Tweet> tweets = currentState.tweets;
                    return RefreshIndicator(
                        onRefresh: () async {
                          callCubit();
                        },
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Tweet tweet = tweets[index];
                            return SingleTweet(
                              tweet: tweet,
                              isDetailsScreen: false,
                            );
                          },
                          itemCount: tweets.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              color: Colors.grey,
                            );
                          },
                        ));
                  }
                })
              ],
            )),
    ),
        ));
  }

  void callCubit() {
    if (searchController.text.isEmpty) return;
    if (cubit.dropDownValue == '@') {
      context.read<SearchCubit>().searchUsers(searchController.text);
    } else if (cubit.dropDownValue == '📝') {
      context.read<SearchCubit>().searchTweets(searchController.text);
    }
  }
}
