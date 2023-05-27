import '../models/user_model.dart';
import '../services/user_service.dart';

class UserRepo {
  final UserService service = UserService();

  Future<void> insertUser(UserModel userModel) async {
    return await service.insertUser(userModel);
  }
  Future<List<UserModel>> searchUsers(String searchTerm,String firebaseId) async {
    return await service.searchUsers(searchTerm,firebaseId);
  }
  Future<UserModel> getUserByFirebaseId(String firebaseId) async {
    return await service.getUserByFirebaseId(firebaseId);
  }
    Future<void> updateUser(UserModel newUser, String firebaseId) async {
    return await service.updateUser(newUser, firebaseId);
  }
  Future<void> followUser(String followerFirebaseId, String followedFirebaseId) async {
    return await service.followUser(followerFirebaseId, followedFirebaseId);
  }
  Future<void> unFollowUser(String followerFirebaseId, String followedFirebaseId) async {
    return await service.unFollowUser(followerFirebaseId, followedFirebaseId);
  }
}
