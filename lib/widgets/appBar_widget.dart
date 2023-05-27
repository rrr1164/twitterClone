import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/assets.dart';
import '../cubit/search/search_cubit.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);
  @override
  final Size preferredSize = const Size(56, 56);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape:
          const Border(bottom: BorderSide(color: Color(0xFFF5F5F5), width: 1)),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
          SearchCubit cubit = context.read<SearchCubit>();
          if(cubit.dropDownValue == '@') {
            cubit.searchUsers(cubit.lastSearch);
          } else {
            cubit.searchTweets(cubit.lastSearch);
          }
        },
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        ),
      ),
      title: Image.asset(
        Assets.twitterLogo,
        width: 55,
      ),
      centerTitle: true,
    );
  }
}
