import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  Future<String> uploadProfilePictureToStorage(XFile image) async {

    try {
      Reference rootReference = FirebaseStorage.instance.ref();
      Reference profilePicturesReference = rootReference.child(
          "profilePictures");
      String uniqueFileName = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      Reference imageToUploadReference =
      profilePicturesReference.child(uniqueFileName);
      await imageToUploadReference.putFile(File(image.path));
      return await imageToUploadReference.getDownloadURL();
    }
    catch(error){
      debugPrint("error uploading image $error");
    }
    return "https://ssl.gstatic.com/images/branding/product/1x/avatar_circle_blue_512dp.png";
  }
  Future<String> uploadTweetImageToStorage(XFile image) async {

    try {
      Reference rootReference = FirebaseStorage.instance.ref();
      Reference profilePicturesReference = rootReference.child(
          "tweetImages");
      String uniqueFileName = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();
      Reference imageToUploadReference =
      profilePicturesReference.child(uniqueFileName);
      await imageToUploadReference.putFile(File(image.path));
      return await imageToUploadReference.getDownloadURL();
    }
    catch(error){
      debugPrint("error uploading image $error");
      throw "error uploading image";
    }
  }
}
