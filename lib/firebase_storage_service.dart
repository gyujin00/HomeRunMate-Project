//firebase_storage_service.dart

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageService {
  static Future<String> uploadProfileImage(String userId, File imageFile) async {
    final ref = FirebaseStorage.instance.ref().child('profile_images').child('$userId.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }
}
