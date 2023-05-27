import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/data/models/user_model.dart';

import '../data/repo/user_repo.dart';

class FollowButtonWidget extends StatefulWidget {
  FollowButtonWidget({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  UserRepo userRepo = UserRepo();

  @override
  State<FollowButtonWidget> createState() => _FollowButtonWidgetState();
}

class _FollowButtonWidgetState extends State<FollowButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return buildFollowButton(widget.user, widget.userRepo);
  }

  ElevatedButton buildFollowButton(UserModel user, UserRepo userRepo) {
    return ElevatedButton(
      onPressed: () async {
        bool oldFollowStatus = user.followedByUser;
        setState(() {
          user.followedByUser = !user.followedByUser;
        });
        if (!oldFollowStatus) {
          await userRepo.followUser(
              FirebaseAuth.instance.currentUser!.uid, user.firebaseId);
        } else {
          await userRepo.unFollowUser(
              FirebaseAuth.instance.currentUser!.uid, user.firebaseId);
        }
      },
      child:
          user.followedByUser ? const Text("Unfollow") : const Text("follow"),
    );
  }
}
