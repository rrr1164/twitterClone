import 'package:image_picker/image_picker.dart';
import 'package:twitterclone/data/services/storage_service.dart';

class StorageRepo {
  StorageService service = StorageService();

  Future<String> uploadProfilePictureToStorage(XFile image) async {
    return await service.uploadProfilePictureToStorage(image);
  }
  Future<String> uploadTweetImageToStorage(XFile image) async {
    return await service.uploadTweetImageToStorage(image);
  }
}
