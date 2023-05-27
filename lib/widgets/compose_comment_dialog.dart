import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitterclone/core/utils/utilities.dart';
import 'package:twitterclone/data/repo/tweets_repo.dart';
import 'package:twitterclone/widgets/loader_dialog.dart';

import '../data/models/tweet.dart';

class ComposeCommentDialog extends StatefulWidget {
  const ComposeCommentDialog({Key? key, required this.tweet}) : super(key: key);
  final Tweet tweet;
  @override
  State<ComposeCommentDialog> createState() => _ComposeCommentDialogState();
}

class _ComposeCommentDialogState extends State<ComposeCommentDialog> {
  TextEditingController commentController = TextEditingController();
  bool _validate = false;
  TweetsRepository tweetsRepository = TweetsRepository();

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
      titlePadding: const EdgeInsets.only(left:5),
      title:
          Container(
            alignment: FractionalOffset.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context,false);
              },
              icon: const Icon(Icons.clear),
            ),
          ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                controller: commentController,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'comment content',
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              CircleAvatar(
                  child: IconButton(
                onPressed: () async {
                  _validate = commentController.text.isEmpty;
                  bool added = false;
                  if (!_validate) {
                    showLoaderDialog(context);
                    try {
                      await tweetsRepository.postComment(
                          commentController.text,widget.tweet.id, FirebaseAuth.instance.currentUser!.uid);
                      added = true;
                    } catch (error) {
                      Utilities.showErrorSnackBar(
                          context, "Error adding commenting");
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                      Navigator.pop(context,added);
                    }
                  }
                },
                icon: const Icon(Icons.send_outlined),
              )),
              const SizedBox(height:25)
            ],
          ),
        ),
      ),
    );
  }
}
