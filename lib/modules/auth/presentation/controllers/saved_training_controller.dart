import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/training/domain/entities/training.dart';
import 'package:champ/modules/training/domain/usecases/training_usecase.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SavedTrainingController extends GetxController {
 final TrainingUsecase _trainingUsecase;
 final User _user;

  SavedTrainingController(this._user, this._trainingUsecase);

  final screenUtil = ScreenUtil();
  final refreshController = RefreshController(initialRefresh: true);
  final lastPage = Rx<bool>(false);
  final currentLastEvaluatedKey = Rx<String>();
  final trainings = RxList<Training>([]);

  @override
  void onInit() {
    print('SavedTrainingController onInit');
    initFeed();
    super.onInit();
  }

  Future<void> fetchTrainingPage() async {
    if (!lastPage.value) {
      final result = await _trainingUsecase.getSavedTrainingByUserId(_user.id, currentLastEvaluatedKey.value);
      print('SavedTrainingController: fetch post page');
      result.fold(
        (failure) { 
          print('SavedTrainingController: result: Failure');
          showErrorSnackbar(failure);
        },
        (trainingPage) {
          print('SavedTrainingController: result: Success');
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

  void initFeed() {
    currentLastEvaluatedKey.value = null;
  }

  Future<void> onRefresh() async {
    currentLastEvaluatedKey.value = null;
    lastPage.value = false;
    await fetchTrainingPage();
    refreshController.refreshCompleted();
  }

  Future<void> onLoadNewPage() async {
    await fetchTrainingPage();
    refreshController.loadComplete();
  }

  void showErrorSnackbar(Failure failure) {

  }
}