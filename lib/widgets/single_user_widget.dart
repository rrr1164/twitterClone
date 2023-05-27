import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/data/models/user_model.dart';
import 'package:twitterclone/data/repo/user_repo.dart';

import '../screens/misc/user_details_screen.dart';
import 'followButton.dart';

class SingleUserWidget extends StatefulWidget {
  SingleUserWidget({Key? key, required this.user}) : super(key: key);
  final UserModel user;
  final UserRepo userRepo = UserRepo();

  @override
  State<SingleUserWidget> createState() => _SingleUserWidgetState();
}

class _SingleUserWidgetState extends State<SingleUserWidget> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserDetailsScreen(user: widget.user)));
          },
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: widget.user.photoUrl,
                    placeholder: (context, url) => const CircleAvatar(
                      backgroundColor: Colors.blue,
                    ),
                    imageBuilder: (context, image) => CircleAvatar(
                      backgroundImage: image,
                    ),
                  ),
                  title: Text(
                    widget.user.userName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: widget.user.firebaseId !=
                          FirebaseAuth.instance.currentUser!.uid
                      ? FollowButtonWidget(user: widget.user)
                      : const SizedBox())),
        ));
  }
}
