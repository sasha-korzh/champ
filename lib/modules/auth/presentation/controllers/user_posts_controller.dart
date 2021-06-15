import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/usecases/post_usecase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserPostsController extends GetxController {
 final PostUsecase _postUsecase;
 final User _user;

  UserPostsController(this._user, this._postUsecase);

  final screenUtil = ScreenUtil();
  final refreshController = RefreshController(initialRefresh: true);
  final lastPage = Rx<bool>(false);
  final currentLastEvaluatedKey = Rx<String>();
  final posts = RxList<Post>([]);

  @override
  void onInit() {
    print('UserPostsController onInit');
    initFeed();
    super.onInit();
  }

  Future<void> fetchPostPage() async {
    if (!lastPage.value) {
      final result = await _postUsecase.getCreatedPostsByUserId(_user.id, currentLastEvaluatedKey.value);
      print('UserPostsController: fetch post page');
      result.fold(
        (failure) { 
          print('UserPostsController: result: Failure');
          showErrorSnackbar(failure);
        },
        (postPage) {
          print('UserPostsController: result: Success');
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

  void initFeed() {
    currentLastEvaluatedKey.value = null;
  }

  Future<void> onRefresh() async {
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