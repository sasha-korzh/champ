
import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/training/domain/entities/training.dart';
import 'package:champ/modules/training/domain/usecases/training_usecase.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TrainingFeedController extends GetxController {
  final TrainingUsecase _trainingUsecase;

  TrainingFeedController(this._trainingUsecase);

  final authController = Get.find<AuthController>();
  final refreshController = RefreshController(initialRefresh: true);
  final lastPage = Rx<bool>(false);
  final currentLastEvaluatedKey = Rx<String>();
  final userTopics = Rx<List<TopicInfo>>([]);
  final trainings = RxList<Training>([]);

  @override
  void onInit() {
    ever(authController.currentUser, initFeed);
    super.onInit();
  }

  Future<void> fetchPostPage() async {
    if (!lastPage.value) {
      final result = await _trainingUsecase.getTrainingByUserTopics(userTopics.value, currentLastEvaluatedKey.value);
      result.fold(
        (failure) { 
          showErrorSnackbar(failure);
        },
        (trainingPage) {
          if (currentLastEvaluatedKey.value == null) {
            trainings.clear();
          }
          if (trainingPage.lastEvaluatedKey == null) {
            lastPage.value = true;
          }
          currentLastEvaluatedKey.value = trainingPage.lastEvaluatedKey;
          trainings.addAll(trainingPage.items);
        }
      );
    }
  }

  void initFeed(User user) {
    currentLastEvaluatedKey.value = null;
    if (user == null) {
      userTopics.value = [];
    } else {
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