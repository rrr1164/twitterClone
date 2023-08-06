import 'package:twitterclone/data/models/user_model.dart';

class Tweet {
  late int _id;
  final String _content;
  late UserModel _poster;
  late int _likes;
  late int _commentsCount;
  late bool _isLiked;
  List<String> _imagesUrls = [];

  Tweet.fromJson(Map json)
      : _id = int.parse(json['tweet_id']),
        _content = json['tweet_content'],
        _likes = int.parse(json['likes']),
        _commentsCount = int.parse(json['comments']),
        _isLiked = json['is_liked'] == "1",
        _poster = UserModel.fromJson(json);

  Tweet({required content}) : _content = content;
  void setPoster(UserModel poster){
    _poster = poster;
  }
  void setImageUrls(List<String> imageUrls){
    _imagesUrls = imageUrls;
  }
  void setId(int id){
    _id = id;
  }
  void setCommentsCount(int commentsCount){
    _commentsCount = commentsCount;
  }
  void setIsLiked(bool isLiked){
    _isLiked = isLiked;
  }
  void setLikes(int likes){
    _likes = likes;
  }
  bool getIsLiked(){
    return _isLiked;
  }
  int getLikes(){
    return _likes;
  }
  int getId(){
    return _id;
  }
  int getCommentsCount(){
    return _commentsCount;
  }
  String getContent(){
    return _content;
  }
  UserModel getPoster(){
    return _poster;
  }
  List<String> getImageUrls(){
    return _imagesUrls;
  }

}
