import 'dart:io';

import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitterclone/core/utils/utilities.dart';
import 'package:twitterclone/data/repo/storage_repo.dart';
import 'package:twitterclone/data/repo/tweets_repo.dart';
import 'package:twitterclone/widgets/loader_dialog.dart';

import '../data/models/tweet.dart';

class ComposeTweetDialog extends StatefulWidget {
  ComposeTweetDialog({Key? key}) : super(key: key);
  final StorageRepo storageRepo = StorageRepo();

  @override
  State<ComposeTweetDialog> createState() => _ComposeTweetDialogState();
}

class _ComposeTweetDialogState extends State<ComposeTweetDialog> {
  TextEditingController tweetController = TextEditingController();
  bool _validate = false;
  TweetsRepository tweetsRepository = TweetsRepository();
  XFile? image;

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
      title: const Text("Compose Tweet"),
      contentPadding: const EdgeInsets.only(
        top: 10.0,
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DetectableTextField(
                controller: tweetController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'What is happening?',
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
                detectionRegExp: detectionRegExp(atSign: false, url: false)!,
              ),
              const SizedBox(
                height: 20,
              ),
              if (image != null)
                Image.file(
                  File(image!.path),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      pickImage();
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blue,
                      size: 36,
                    ),
                  ),
                  CircleAvatar(
                      child: IconButton(
                    onPressed: () async {

                      _validate =
                          tweetController.text.isEmpty;
                      if (!_validate) {
                        showLoaderDialog(context);
                        try {
                          Tweet tweet = Tweet(content: tweetController.text);
                          if (image != null) {
                            tweet.imageUrl = await uploadTweetImage(image!);
                          }
                          await tweetsRepository.insertTweet(
                              tweet, FirebaseAuth.instance.currentUser!.uid);
                        } catch (error) {
                          Utilities.showErrorSnackBar(
                              context, "Error adding tweet");
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.of(context).pop();
                        }
                      } else {
                        Utilities.showErrorSnackBar(
                            context, "can't have more than 1 hashtag");
                      }
                    },
                    icon: const Icon(Icons.send_outlined),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadTweetImage(XFile image) async {
    try {
      return await widget.storageRepo.uploadTweetImageToStorage(image);
    } catch (error) {
      throw "error uploading tweet image ";
    }
  }

}
