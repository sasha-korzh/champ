import 'package:champ/modules/auth/presentation/auth_binding.dart';
import 'package:champ/modules/auth/presentation/pages/user_profile_page.dart';
import 'package:champ/modules/post_feed/post_binding.dart';
import 'package:champ/modules/post_feed/presentation/controllers/editor_controller.dart';
import 'package:champ/modules/post_feed/presentation/pages/feed_page.dart';
import 'package:champ/modules/post_feed/presentation/pages/post_editor_page.dart';
import 'package:champ/modules/post_feed/presentation/pages/post_page.dart';
import 'package:champ/modules/screen_util_init/screen_util_init_page.dart';
import 'package:champ/modules/training/presentation/pages/create_training_page.dart';
import 'package:champ/modules/training/presentation/pages/training_feed_page.dart';
import 'package:champ/modules/training/presentation/pages/training_page.dart';
import 'package:champ/modules/training/training_binding.dart';
import 'package:get/get.dart';

import '../../../modules/home/home_binding.dart';
import '../../../modules/home/home_page.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.initial;

  static final pages = [
    GetPage(
      name: Routes.feed,
      page: () => FeedPage(),
      binding: PostBinding(),
      transition: Transition.cupertino,
    ),    
    GetPage(
      name: Routes.trainingPage,
      page: () => TrainingPage(),
      transition: Transition.cupertino,
    ),    
    GetPage(
      name: Routes.initial,
      page: () => ScreenUtilInitPage(),
      transition: Transition.cupertino,
    ),    
    GetPage(
      name: Routes.home,
      page: () => HomePage(),
      bindings: [
        AuthBinding(),  
        HomeBinding(),
        PostBinding(),
        TrainingFeedBinding(),
      ],
      transition: Transition.cupertino,
    ),    
    GetPage(
      name: Routes.userProfile,
      page: () => UserProfilePage(),
      transition: Transition.cupertino,
    ),    
    GetPage(
      name: Routes.postPage,
      page: () => PostPage(),
      transition: Transition.cupertino,
    ),    
    GetPage(
      name: Routes.createTraining,
      page: () => CreateTrainingPage(),
      transition: Transition.cupertino,
    ),    
    GetPage(
      name: Routes.postEditor,
      page: () => PostEditorPage(),
      binding: BindingsBuilder.put(() => EditorController()),
      transition: Transition.cupertino,
    ),    
  ];
}