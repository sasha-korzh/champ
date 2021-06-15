

import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/training/domain/entities/training.dart';
import 'package:champ/modules/training/domain/usecases/training_usecase.dart';
import 'package:get/get.dart';

class TrainingController extends GetxController {
  final AuthController authController = Get.find();
  final TrainingUsecase _trainingUsecase;
  final likedTrainingsIds = RxMap<String, String>({});
  
  TrainingController(this._trainingUsecase);

  @override
  void onInit() {
    ever(authController.currentUser, fetchLikedTrainingIds);
    super.onInit();
  }

  Future<void> fetchLikedTrainingIds(User currentUser) async {
    likedTrainingsIds.clear();
    if (currentUser != null) {
      final postsIds = await _trainingUsecase.getLikedTrainingsByUserId(currentUser.id);
      likedTrainingsIds.addAll(postsIds);
    }
  }

  likeTraining(Training training) {
    if (authController.currentUser.value != null) {
      likedTrainingsIds[training.id] = DateTime.now().millisecondsSinceEpoch.toString();
      _trainingUsecase.createTrainingLike(
        training.id,
        authController.currentUser.value.id,
        training.likesCount + 1,
        likedTrainingsIds
      );
    } else {
      authController.showSignInSnackBar();
    }
  }

  unlikeTraining(Training training) {
    _trainingUsecase.deleteTrainingLike(
      training.id,
      authController.currentUser.value.id,
      training.likesCount - 1,
      likedTrainingsIds[training.id],
    );
  }
}