
import 'package:champ/modules/training/data/datasources/remote_training_datasource.dart';
import 'package:champ/modules/training/domain/repositories/training_repository.dart';
import 'package:champ/modules/training/presentation/controllers/training_controller.dart';
import 'package:champ/modules/training/presentation/controllers/training_feed_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import 'data/repositories/training_repository_impl.dart';
import 'domain/usecases/training_usecase.dart';

class TrainingFeedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemoteTrainingDatasource>(
      () => FakeTrainingDatasource());
    Get.lazyPut<TrainingRepository>(
      () => TrainingRepositoryImpl(
        remoteDataSource: Get.find(),
        networkInfo: Get.find(),
    ));
    Get.lazyPut<TrainingUsecase>(() => TrainingUsecase(trainingRepository: Get.find(), localStorage: Get.find()));
    Get.lazyPut<TrainingFeedController>(() => TrainingFeedController(Get.find()));
    Get.put<TrainingController>(TrainingController(Get.find()));
    // Get.lazyPut<PostController>(() => PostController(Get.find()));
  }

}