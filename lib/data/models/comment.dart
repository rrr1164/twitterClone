import 'package:twitterclone/data/models/user_model.dart';

class Comment {
  late int id;
  String content;
  late UserModel poster;

  Comment.fromJson(Map json)
      : id = int.parse(json['comment_id']),
        content = json['comment_content'],
        poster = UserModel.threeValues(
            photoUrl: json['photoUrl'],
            userName: json['user_name'],
            firebaseId: json['commenter_firebase_id']);

  Comment({required this.content});
}
