import 'package:twitterclone/data/models/user_model.dart';

class Tweet {
  late int id;
  String content;
  late UserModel poster;
  late int likes;
  late int commentsCount;
  late bool isLiked;
  String? imageUrl;
  Tweet.fromJson(Map json)
      : id = int.parse(json['tweet_id']),
        content = json['tweet_content'],
        likes = int.parse(json['likes']),
        commentsCount = int.parse(json['comments']),
        isLiked = json['is_liked'] == "1",
        imageUrl = json['tweet_image'],
        poster = UserModel.fromJson(json);

  Tweet({required this.content});
}
