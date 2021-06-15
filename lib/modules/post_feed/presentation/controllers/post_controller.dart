

import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/post_feed/domain/usecases/post_usecase.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  final AuthController authController = Get.find();
  final PostUsecase _postUsecase;
  final likedPostsIds = RxList<String>([]);
  
  PostController(this._postUsecase);

  @override
  void onInit() {
    ever(authController.currentUser, fetchLikedPostsIds);
    super.onInit();
  }

  Future<void> fetchLikedPostsIds(User currentUser) async {
    likedPostsIds.clear();
    if (currentUser != null) {
      final postsIds = _postUsecase.getLikedPostsByUserId(currentUser.id);
      likedPostsIds.addAll(postsIds);
      // likedPostsIds.update(key, (value) => null)
    }
  }

  Future<int> likePost(Post post) async {
    if (authController.currentUser.value != null) {
      likedPostsIds.add(post.id);
      _postUsecase.createPostLike(
        post.id,
        authController.currentUser.value.id,
        post.likesCount + 1,
        likedPostsIds
      );
      print('LIKES: likedPostsIds: $likedPostsIds');
      return post.likesCount + 1;
    } else {
      authController.showSignInSnackBar();
      return post.likesCount;
    }
  }

  Future<int> unlikePost(Post post) async {
    if (authController.currentUser.value != null) {
      likedPostsIds.remove(post.id);
      await _postUsecase.deletePostLike(
        post.id,
        authController.currentUser.value.id,
        post.likesCount - 1,
        likedPostsIds,
      );
      print('LIKES: likedPostsIds: $likedPostsIds');
      return post.likesCount - 1;
    } else {
      authController.showSignInSnackBar();
      return post.likesCount;
    }
  }

  Future<Post> createPost(TopicInfo topicInfo) async {
    final result = await _postUsecase.createPost(null, null, UserShortInfo(
      id: authController.currentUser.value.id,
      avatarImageUrl: authController.currentUser.value.avatarImageUrl,
      fullname: authController.currentUser.value.fullname
    ));
    await Future.delayed(Duration(milliseconds: 1000));
    return result.fold((l) => null, (r) => r);
  }
}