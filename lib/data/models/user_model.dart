class UserModel {
  late String photoUrl;
  final String userName;
  final String firebaseId;
  late bool followedByUser;
  UserModel.fromJson(Map json)
      : userName = json['user_name'],
        photoUrl = json['photoUrl'],
        firebaseId = json['firebase_id'],
        followedByUser = json['isFollowing'] == "1";

  UserModel.twoValues({ required this.userName,required this.firebaseId});

  UserModel.threeValues({required this.photoUrl, required this.userName,required this.firebaseId});
}
