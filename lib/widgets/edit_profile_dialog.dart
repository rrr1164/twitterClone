import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitterclone/widgets/profile_widget.dart';

import '../data/models/user_model.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({Key? key, required this.user}) : super(key: key);
  final UserModel user;

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  XFile? image;

  String userName = "";

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (image == null) return;
      final imageTemporary = XFile(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException {
      debugPrint("Failed to pick Image");
    }
  }

  @override
  void initState() {
    super.initState();
    userName = widget.user.userName;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20.0,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.only(
        top: 10.0,
      ),
      title: const ProfileTitleWidget(),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            profilePictureWidget(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16, top: 20),
              child: TextFormField(
                onChanged: (text) {
                  setState(() {
                    if (text.isNotEmpty) {
                      userName = text;
                    }
                  });
                },
                initialValue: userName,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: image != null
                  ? submitEditProfileButton(userName, context, image: image)
                  : submitEditProfileButton(userName, context,
                      photoUrl: widget.user.photoUrl),
            ),
          ],
        ),
      ),
    );
  }

  Widget profilePictureWidget() {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          pickImage();
        },
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.file(
                  File(image!.path),
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ))
            : CachedNetworkImage(
                imageUrl: widget.user.photoUrl,
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 50,
                ),
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundImage: image,
                  radius: 50,
                ),
              ),
      )
    ]);
  }
}
