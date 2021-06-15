
import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/post_feed/domain/usecases/post_usecase.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TopicController extends GetxController {
  final PostUsecase _postUsecase;

  TopicController(this._postUsecase);

  final authController = Get.find<AuthController>();
  final refreshController = RefreshController(initialRefresh: true);
  final lastPage = Rx<bool>(false);
  final currentLastEvaluatedKey = Rx<String>();
  final topics = RxList<Topic>([]);


  Future<void> fetchTopics() async {
    if (!lastPage.value) {
      final result = await _postUsecase.getAllTopics();
      result.fold(
        (failure) { 
          showErrorSnackbar(failure);
        },
        (topicsResult) {
          lastPage.value = true;
          topics.addAll(topicsResult);
        }
      );
    }
  }

  Future<void> onRefreshFeed() async {
    currentLastEvaluatedKey.value = null;
    await fetchTopics();
    refreshController.refreshCompleted();
  }

  Future<void> onLoadNewPage() async {
    await fetchTopics();
    refreshController.loadComplete();
  }

  void showErrorSnackbar(Failure failure) {

  }

}