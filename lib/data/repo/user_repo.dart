import '../models/user_model.dart';
import '../services/user_service.dart';

class UserRepo {
  final UserService service = UserService();

  Future<void> insertUser(UserModel userModel) async {
    try{
      return await service.insertUser(userModel);
    }
    catch(error){
      throw error.toString();
    }
  }
  Future<List<UserModel>> searchUsers(String searchTerm,String firebaseId) async {
    try{
      return await service.searchUsers(searchTerm,firebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }
  Future<UserModel> getUserByFirebaseId(String firebaseId) async {
    try{
      return await service.getUserByFirebaseId(firebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }
    Future<void> updateUser(UserModel newUser, String firebaseId) async {
      try{
        return await service.updateUser(newUser,firebaseId);
      }
      catch(error){
        throw error.toString();
      }
  }
  Future<void> followUser(String followerFirebaseId, String followedFirebaseId) async {
    try{
      return await service.followUser(followerFirebaseId,followedFirebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }
  Future<void> unFollowUser(String followerFirebaseId, String followedFirebaseId) async {
    try{
      return await service.unFollowUser(followerFirebaseId,followedFirebaseId);
    }
    catch(error){
      throw error.toString();
    }
  }
}
