import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:twitterclone/core/utils/utilities.dart';

import '../models/user_model.dart';

class UserService {
  Future<void> insertUser(UserModel userModel) async {
    String request =
        "${Utilities.baseApiUrl}/insert_user.php?firebase_id=${userModel.firebaseId}&user_name=${userModel.userName}";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("inserting user request: $request");
    debugPrint("inserting user return status code: ${response.statusCode}");
    if (response.statusCode != 201) {
      throw "error inserting user ${response.statusCode}";
    }
  }
  Future<void> followUser(String followerFirebaseId, String followedFirebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/follow_user.php?follower_firebase_id=$followerFirebaseId&followed_firebase_id=$followedFirebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("following user request: $request");
    debugPrint("following user return status code: ${response.statusCode}");
    if (response.statusCode != 201) {
      throw "error following user ${response.statusCode}";
    }
  }
  Future<void> unFollowUser(String followerFirebaseId, String followedFirebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/unfollow_user.php?follower_firebase_id=$followerFirebaseId&followed_firebase_id=$followedFirebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("following user request: $request");
    debugPrint("following user return status code: ${response.statusCode}");
    if (response.statusCode != 201) {
      throw "error following user ${response.statusCode}";
    }
  }
  Future<List<UserModel>> searchUsers(
      String searchTerm, String firebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/search_users.php?search_term=$searchTerm&firebase_id=$firebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("searching users by term request: $request");
    debugPrint("searching users by term status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return convertDynamicToUsers(
            jsonDecode(response.body) as List<dynamic>);
      }
      else {
        return [];
      }
    } else{
      throw "error searching users by term ${response.statusCode}";
    }
  }

  Future<void> updateUser(UserModel newUser, String firebaseId) async {
    String photoUrl = Uri.encodeComponent(newUser.photoUrl);
    String request =
        "${Utilities.baseApiUrl}/update_user.php?photourl=$photoUrl&user_name=${newUser.userName}&firebase_id=$firebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("updating user request: $request");
    debugPrint("updating user return status code: ${response.statusCode}");
    if (response.statusCode != 201) {
      throw "error updating user ${response.statusCode}";
    }
  }

  Future<UserModel> getUserByFirebaseId(String firebaseId) async {
    String request =
        "${Utilities.baseApiUrl}/get_user_by_firebase_id.php?firebase_id=$firebaseId";
    http.Response response = await http.get(Uri.parse(request));
    debugPrint("getting user by Firebase Uid request: $request");
    debugPrint(
        "getting user by Firebase Uid status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return UserModel.fromJson(jsonDecode(response.body));
      }
      else {
        throw "error searching users by term ${response.statusCode}";
      }
    } else{
      throw "error searching users by term ${response.statusCode}";
    }
  }

  List<UserModel> convertDynamicToUsers(List<dynamic> dynamicUsers) {
    List<UserModel> users = [];
    for (Map<String, dynamic> map in dynamicUsers) {
      if (map.isNotEmpty) {
        UserModel user = UserModel.fromJson(map);
        users.add(user);
      }
    }
    return users;
  }
}
