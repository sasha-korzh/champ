import 'dart:io';

import 'package:champ/core/error/exception.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class RemoteStorage {
  Future<String> uploadFile(File file);
}

class FirebaseRemoteStorage extends RemoteStorage {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(File file) async {
    try {
      final uploadTask = await firebaseStorage
          .ref('files')
          .putFile(file);
      return uploadTask.ref.getDownloadURL();    
    } on  FirebaseException catch (e) {
      throw RemoteStorageException(e.message);
    }
  }

}