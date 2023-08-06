import 'package:image_picker/image_picker.dart';
import 'package:twitterclone/data/services/storage_service.dart';

class StorageRepo {
  StorageService service = StorageService();

  Future<String> uploadProfilePictureToStorage(XFile image) async {
    try{
      return await service.uploadProfilePictureToStorage(image);
    }
    catch(error){
      throw error.toString();
    }
  }
  Future<String> uploadTweetImageToStorage(XFile image) async {
    try{
      return await service.uploadTweetImageToStorage(image);
    }
    catch(error){
      throw error.toString();
    }
  }
}
