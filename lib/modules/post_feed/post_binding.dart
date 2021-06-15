
import 'package:champ/modules/post_feed/data/datasources/remote_fake_post_datasource.dart';
import 'package:champ/modules/post_feed/data/datasources/remote_post_datasource.dart';
import 'package:champ/modules/post_feed/data/mappers/post_mapper.dart';
import 'package:champ/modules/post_feed/data/repositories/post_repository_impl.dart';
import 'package:champ/modules/post_feed/domain/repositories/post_repository.dart';
import 'package:champ/modules/post_feed/domain/usecases/post_usecase.dart';
import 'package:champ/modules/post_feed/presentation/controllers/feed_controller.dart';
import 'package:champ/modules/post_feed/presentation/controllers/post_controller.dart';
import 'package:champ/modules/post_feed/presentation/controllers/topic_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RemotePostDataSource>(
      () => RemoteFakePostDataSource());
    Get.lazyPut<PostRepository>(
      () => PostRepositoryImpl(
        remoteDataSource: Get.find(),
        networkInfo: Get.find(),
        remoteStorage: Get.find(),
    ));
    Get.lazyPut<PostUsecase>(() => PostUsecase(postRepository: Get.find(), localStorage: Get.find()));
    Get.lazyPut<FeedController>(() => FeedController(Get.find()));
    Get.lazyPut<TopicController>(() => TopicController(Get.find()));
    Get.lazyPut<PostController>(() => PostController(Get.find()));
  }

}