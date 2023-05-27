import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitterclone/cubit/bottomNavigation/bottom_navigation_cubit.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'messages_screen.dart';
import 'search_screen.dart';

class ScreensNavigator extends StatefulWidget {
  const ScreensNavigator({Key? key}) : super(key: key);

  @override
  State<ScreensNavigator> createState() => _ScreensNavigatorState();
}

class _ScreensNavigatorState extends State<ScreensNavigator> {
  final _pageNavigation = [
    const HomeScreen(),
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavigationCubit, int>(builder: (context, state) {
      return Scaffold(
        body: _buildBody(state),
        bottomNavigationBar: _buildBottomNav(),
      );
    });
  }

  Widget _buildBody(int index) {
    return _pageNavigation.elementAt(index);
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: context.read<BottomNavigationCubit>().state,
      type: BottomNavigationBarType.fixed,
      onTap: (index) =>
          BlocProvider.of<BottomNavigationCubit>(context).pressedState(index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
      ],
    );
  }
}
