
import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/post_feed/domain/usecases/post_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FeedController extends GetxController {
  final PostUsecase _postUsecase;

  FeedController(this._postUsecase);

  final screenUtil = ScreenUtil();
  final authController = Get.find<AuthController>();
  final refreshController = RefreshController(initialRefresh: true);
  final lastPage = Rx<bool>(false);
  final currentLastEvaluatedKey = Rx<String>();
  final userTopics = Rx<List<TopicInfo>>([]);
  final posts = RxList<Post>([]);

  @override
  void onInit() {
    ever(authController.currentUser, initFeed);
    print('FeedController onInit');
    super.onInit();
  }

  Future<void> fetchPostPage() async {
    if (!lastPage.value) {
      final result = await _postUsecase.getPostsByUserTopics(userTopics.value, currentLastEvaluatedKey.value);
      print('FeedController: fetch post page');
      result.fold(
        (failure) { 
          print('FeedController: result: Failure');
          showErrorSnackbar(failure);
        },
        (postPage) {
          print('FeedController: result: Success');
          if (currentLastEvaluatedKey.value == null) {
            posts.clear();
          }
          if (postPage.lastEvaluatedKey == null) {
            lastPage.value = true;
          }
          currentLastEvaluatedKey.value = postPage.lastEvaluatedKey;
          posts.addAll(postPage.items);
        }
      );
    }
  }

  void initFeed(User user) {
    currentLastEvaluatedKey.value = null;
    if (user == null) {
      print('FeedController: user == null');
      userTopics.value = [
        
      ];
    } else {
      print('FeedController: user != null');
      userTopics.value = user.topics;
    }
  }

  Future<void> onRefreshFeed() async {
    currentLastEvaluatedKey.value = null;
    lastPage.value = false;
    await fetchPostPage();
    refreshController.refreshCompleted();
  }

  Future<void> onLoadNewPage() async {
    await fetchPostPage();
    refreshController.loadComplete();
  }

  void showErrorSnackbar(Failure failure) {

  }

}