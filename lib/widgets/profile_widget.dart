import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitterclone/core/utils/utilities.dart';
import 'package:twitterclone/data/repo/user_repo.dart';

import '../cubit/home/home_cubit.dart';
import '../data/models/user_model.dart';
import '../data/repo/storage_repo.dart';
import 'loader_dialog.dart';

Widget submitEditProfileButton(String userName, BuildContext context,
    {XFile? image,
    String photoUrl =
        "https://ssl.gstatic.com/images/branding/product/1x/avatar_circle_blue_512dp.png"}) {
  StorageRepo storageRepo = StorageRepo();
  UserRepo userRepo = UserRepo();
  return Container(
    width: double.infinity,
    height: 60,
    padding: const EdgeInsets.only(top: 15.0),
    child: ElevatedButton(
      onPressed: () async {
        showLoaderDialog(context);
        try {
          String imageUrl = image != null
              ? await storageRepo.uploadProfilePictureToStorage(image)
              : photoUrl;
          UserModel newUser =
              UserModel.threeValues(photoUrl: imageUrl, userName: userName,firebaseId: FirebaseAuth.instance.currentUser!.uid);
          await userRepo.updateUser(
              newUser, FirebaseAuth.instance.currentUser!.uid);
        } catch (error) {
          Utilities.showErrorSnackBar(context, "Error updating user");
        }
        if (context.mounted) {
          Navigator.pop(context);
          Navigator.of(context).pop();
          context
              .read<HomeCubit>()
              .fetchTweets(FirebaseAuth.instance.currentUser!.uid);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        // fixedSize: Size(250, 50),
      ),
      child: const Text(
        "Submit",
      ),
    ),
  );
}

class ProfileTitleWidget extends StatelessWidget {
  const ProfileTitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        "Edit Profile",
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }
}
