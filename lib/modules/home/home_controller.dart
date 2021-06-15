

import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/post_feed/presentation/pages/feed_page.dart';
import 'package:champ/modules/post_feed/presentation/pages/topic_page.dart';
import 'package:champ/modules/training/presentation/pages/training_feed_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/util/pages/app_pages.dart';

class HomeController extends GetxController {
  FeedPage feedPage;
  TrainingFeedPage trainingFeedPage;
  // SettingsPage settingsPage;
  // BookmarksPage bookmarksPage;
  TopicPage topicsPage;
  // SearchPage searchPage;
  final AuthController authController = Get.find();
  final menuSelectedItem = Rx<MenuItem>();
  final isCollapsed = Rx<bool>(false);
  final currentPage = Rx<Widget>();

  @override
  void onReady() {
    feedPage = FeedPage();
    trainingFeedPage = TrainingFeedPage();
    topicsPage = TopicPage();
    currentPage.value = feedPage;
    menuSelectedItem.value = MenuItem.feed;
    super.onReady();
  }

  void goTo(MenuItem menuItem) {
    switch (menuItem) {
      case MenuItem.userProfile:
        Get.toNamed(Routes.userProfile, arguments: authController.currentUser.value);
        isCollapsed.value = false;
        break;
      case MenuItem.feed:
        currentPage.value = feedPage;
        menuSelectedItem.value = menuItem;
        isCollapsed.value = false;
        break;
      case MenuItem.training:
        currentPage.value = trainingFeedPage;
        menuSelectedItem.value = menuItem;
        isCollapsed.value = false;
        break;
      case MenuItem.notifications:
        break;
      case MenuItem.settings:
        break;
      case MenuItem.bookmarks:
        break;
      case MenuItem.create:
        break;
      case MenuItem.topics:
        currentPage.value = topicsPage;
        menuSelectedItem.value = menuItem;
        isCollapsed.value = false;
        break;
      case MenuItem.search:
        break;
      default:
        
    }
  }

}

enum MenuItem {
  feed,
  userProfile,
  training,
  search,
  bookmarks,
  topics,
  create,
  notifications,
  settings,
}

extension MenuItemIndex on MenuItem {
  int get index {
    switch (this) {
      case MenuItem.create:
        return 0;
      case MenuItem.bookmarks:
        return 1;
      case MenuItem.topics:
        return 2;
      case MenuItem.search:
        return 3;
      case MenuItem.feed:
        return 4;
      case MenuItem.training:
        return 5;
      case MenuItem.notifications:
        return 6;
      case MenuItem.settings:
        return 7;
      default:
        return 0;
    }
  }

  String get name {
    switch (this) {
      case MenuItem.create:
        return 'Создать';
      case MenuItem.bookmarks:
        return 'Закладки';
      case MenuItem.topics:
        return 'Подписки';
      case MenuItem.search:
        return 'Поиск';
      case MenuItem.feed:
        return 'Моя лента';
      case MenuItem.training:
        return 'Тренировки';
      case MenuItem.notifications:
        return 'Уведомления';
      case MenuItem.settings:
        return 'Настройки';
      default:
        return 'Моя лента';
    }
  }

  String get icon {
    switch (this) {
      case MenuItem.create:
        return 'assets/icons/plus.png';
      case MenuItem.bookmarks:
        return 'assets/icons/clock.png';
      case MenuItem.topics:
        return 'assets/icons/list_checklist.png';
      case MenuItem.search:
        return 'assets/icons/search.png';
      case MenuItem.feed:
        return 'assets/icons/home_outline.png';
      case MenuItem.training:
        return 'assets/icons/list_checklist_alt.png';
      case MenuItem.notifications:
        return 'assets/icons/notification_outline.png';
      case MenuItem.settings:
        return 'assets/icons/settings.png';
      default:
        return 'assets/icons/settings.png';
    }
  }
}