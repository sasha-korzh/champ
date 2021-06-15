

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

abstract class LocalStorage {
  Future<void> saveToken(String token);

  String getToken();

  Future<void> deleteToken();

  Future<void> saveLikedPosts(String userId, String likedTrainingIds);

  Future<void> saveLikedTrainings(String userId, String likedTrainingIds);

  String fetchLikedPosts(String userId);

  String fetchLikedTrainings(String userId);
}

class GetxLocalStorage extends LocalStorage {
  final GetStorage box;

  GetxLocalStorage(this.box);

  @override
  Future<void> deleteToken() async {
    box.remove(LocalStorageKeys.token);
  }

  @override
  String getToken() {
    return box.read<String>(LocalStorageKeys.token);
  }

  @override
  Future<void> saveToken(String token) async {
    box.write(LocalStorageKeys.token, token);
  }

  @override
  Future<void> saveLikedPosts(String userId, String likedPostsIds) async {
    box.write(userId, likedPostsIds);
  }

  @override
  String fetchLikedPosts(String userId) {
    return box.read<String>(userId);
  }

  @override
  String fetchLikedTrainings(String userId) {
    return box.read<String>(LocalStorageKeys.likedTrainings);
  }

  @override
  Future<void> saveLikedTrainings(String userId, String likedTrainingIds) async {
    box.write(LocalStorageKeys.likedTrainings, likedTrainingIds);
  }

}

class LocalStorageKeys {
  static const token = 'user_token_key';
  static const likedTrainings = 'user_liked_trainings_key';

}
