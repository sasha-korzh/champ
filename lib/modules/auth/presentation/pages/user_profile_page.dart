import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/pages/app_pages.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/auth/presentation/controllers/saved_training_controller.dart';
import 'package:champ/modules/auth/presentation/controllers/user_posts_controller.dart';
import 'package:champ/modules/auth/presentation/controllers/user_training_controller.dart';
import 'package:champ/modules/auth/presentation/widgets/paginated_list_view.dart';
import 'package:champ/core/widgets/page_app_bar.dart';
import 'package:champ/modules/post_feed/presentation/widgets/post_list_item.dart';
import 'package:champ/modules/training/presentation/widgets/training_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatelessWidget {
  final ScreenUtil su = ScreenUtil();
  final AuthController authController = Get.find();
  final User user = Get.arguments;

  UserProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PageAppBar(
        title: 'Профиль',
        onMorePressed: () {},
      ),
      body: Column(
        children: [
          getUserProfileHeader(),
          Container(
            height: su.setHeight(8),
            margin: EdgeInsets.symmetric(vertical: su.setHeight(30)),
            color: AppColors.grey,
          ),
          Expanded(
            // height: su.setHeight(500),
            child: getTabBarSection()
          ),
        ],
      ),
    );
  }

  Widget getUserProfileHeader() {
    return Container(
      padding: EdgeInsets.only(
        left: su.setWidth(20),
        right: su.setWidth(20),
        top: su.setWidth(20),
      ),
      child: Column(
        children: [
          getAvatarSection(),
          SizedBox(height: su.setHeight(20)),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                getIconWithText('assets/icons/user_circle_black.png',
                    '${user.followers.length} подписчиков'),
                SizedBox(width: su.setWidth(7)),
                getIconWithText('assets/icons/list_checklist.png',
                    '${user.followings.length} подписок'),
              ],
            ),
          ),
          SizedBox(height: su.setHeight(20)),
          getButtonSection(),
        ],
      ),
    );
  }

  Widget getAvatarSection() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getAvatarImage(),
          SizedBox(width: su.setWidth(14)),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: su.setHeight(10)),
                Text(
                  user.fullname,
                  style: TextStyles.weight500px16(),
                ),
                SizedBox(height: su.setHeight(10)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getAvatarImage() {
    return Container(
      height: su.setHeight(80),
      width: su.setHeight(80),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
            fit: BoxFit.cover,
            alignment: FractionalOffset.center,
            image: NetworkImage(user.avatarImageUrl)),
      ),
    );
  }

  Widget getIconWithText(String path, String text) {
    return Container(
      child: Row(
        children: [
          getIcon(path),
          SizedBox(width: su.setWidth(7)),
          Text(
            text,
            style: TextStyles.weight400px12(),
          )
        ],
      ),
    );
  }

  Widget getIcon(String path) {
    return Container(
      width: su.setWidth(18),
      height: su.setWidth(18),
      child: Image.asset(path),
    );
  }

  Widget getButtonSection() {
    var color;
    var text;
    var textColor;
    var onPressed;
    if (user == authController.currentUser.value) {
      color = AppColors.grey;
      textColor = AppColors.black;
      text = 'Выйти';
      onPressed = () {
        authController.signOutUser();
        Get.back();
      };
    } else {
      if (authController.currentUser.value.followings
          .any((e) => e.id == user.id)) {
        color = AppColors.grey;
        textColor = AppColors.black;
        text = 'Подписан';
        onPressed = () {
          authController.unfollow(user.id);
        };
      } else {
        color = AppColors.black;
        textColor = AppColors.white;
        text = 'Подписаться';
        onPressed = () {
          authController.follow(user.id);
        };
      }
    }

    return Container(
      child: Row(
        children: [
          Container(
            width: su.setWidth(153),
            height: su.setHeight(42),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: color),
            child: FlatButton(
              onPressed: onPressed,
              child: Text(
                text,
                style: TextStyles.weight500px14(color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTabBarSection() {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Column(
        children: [
          Container(
            height: su.setHeight(30),
            padding: EdgeInsets.symmetric(horizontal: su.setWidth(27)),
            child: TabBar(
              onTap: (index) {},
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: AppColors.grey,
              ),
              labelColor: AppColors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: EdgeInsets.all(10),
              tabs: [
                Tab(text: 'Посты'),
                Tab(text: 'Тренировки'),
                Tab(text: 'Сохраненные'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                GetBuilder<UserPostsController>(
                  init: UserPostsController(user, Get.find()),
                  builder: (controller) {
                    return Obx(() => PaginatedListView(
                      refreshController: controller.refreshController,
                      onRefresh: controller.onRefresh,
                      onLoadNewPage: controller.onLoadNewPage,
                      itemBuilder: (context, index) {
                        final post = controller.posts[index];
                        final notLast = index < controller.posts.length;
                        return Column(
                          children: [
                            PostListItem(post: post),
                            notLast ? 
                              Container(
                                height: controller.screenUtil.setHeight(8),
                                color: AppColors.grey,
                              )
                            : 
                              Container()
                          ],
                        );
                      },
                      itemsCount: controller.posts.length
                    ));
                  },
                ),
                GetBuilder<UserTrainingController>(
                  init: UserTrainingController(user, Get.find()),
                  builder: (controller) {
                    return Obx(() => Padding(
                      padding: EdgeInsets.only(top: su.setHeight(24)),
                      child: PaginatedListView(
                        refreshController: controller.refreshController,
                        onRefresh: controller.onRefresh,
                        onLoadNewPage: controller.onLoadNewPage,
                        itemBuilder: (context, index) {
                          return Center(child: Padding(
                            padding: EdgeInsets.only(bottom: su.setHeight(44)),
                            child: TrainingListItem(training: controller.trainings[index]),
                          ));
                        },
                        itemsCount: controller.trainings.length
                      ),
                    ));
                  },
                ),
                GetBuilder<SavedTrainingController>(
                  init: SavedTrainingController(user, Get.find()),
                  builder: (controller) {
                    return PaginatedListView(
                      refreshController: controller.refreshController,
                      onRefresh: controller.onRefresh,
                      onLoadNewPage: controller.onLoadNewPage,
                      itemBuilder: (context, index) {

                      },
                      itemsCount: controller.trainings.length
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
