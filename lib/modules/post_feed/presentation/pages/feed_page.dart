
import 'package:champ/core/util/pages/app_pages.dart';
import 'package:champ/modules/home/home_controller.dart';
import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/no_glow_scroll_behavior.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/modules/post_feed/presentation/controllers/feed_controller.dart';
import 'package:champ/modules/post_feed/presentation/controllers/post_controller.dart';
import 'package:champ/modules/post_feed/presentation/widgets/post_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class FeedPage extends StatelessWidget {
  final FeedController feedController = Get.find();
  final HomeController homeController = Get.find();
  final PostController postController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SmartRefresher(
          controller: feedController.refreshController,
          onRefresh: feedController.onRefreshFeed,
          onLoading: feedController.onLoadNewPage,
          enablePullDown: true,
          enablePullUp: true,
          footer: getCustomFooter(),
          header: getCustomHeader(),
          child: ListView.builder(
            itemBuilder: (context, index) {
               final post = feedController.posts[index];
               final notLast = index < feedController.posts.length;
               return Obx(() {
                 final isLiked = postController.likedPostsIds.contains(post.id);
                 return Column(
                 children: [
                   GestureDetector(
                     onTap: () {
                       Get.toNamed(Routes.postPage, arguments: post);
                     },
                     child: PostListItem(post: post),
                   ),
                   notLast ? 
                     Obx(() => AnimatedContainer(
                       duration: Duration(milliseconds: 300),
                       height: feedController.screenUtil.setHeight(8),
                       margin: homeController.isCollapsed.value ?
                          EdgeInsets.only(left: feedController.screenUtil.setWidth(30))
                        :
                          EdgeInsets.zero,
                       color: AppColors.grey,
                     )) 
                   : 
                     Container()
                 ],
               );
               });
            },
            itemCount: feedController.posts.length,
          ),
        ),
      )),
    );
  }

  Widget getCustomHeader() {
    return CustomHeader(
      refreshStyle: RefreshStyle.Follow,
      builder: (BuildContext context, RefreshStatus status){
        Widget text;
        switch (status) {
          case RefreshStatus.canRefresh:
          case RefreshStatus.idle:
            text =  Text('Update', style: TextStyles.weight400px14());
            break;
          case RefreshStatus.refreshing:
            text = Text('Loading', style: TextStyles.weight400px14());
            break;
          case RefreshStatus.completed:
            text =  Text('Completed', style: TextStyles.weight400px14());
            break;
          default:
            text = Text('Error', style: TextStyles.weight400px14());
        }
  
        return Container(
          height: 55.0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(),
                SizedBox(width: 10),
                text
              ],
            )
          ),
        );
      },
    );
  }

  Widget getCustomFooter() {
    return CustomFooter(
      loadStyle: LoadStyle.ShowWhenLoading,
      builder: (BuildContext context, LoadStatus status){
        Widget text;
        switch (status) {
          case LoadStatus.canLoading:
          case LoadStatus.idle:
            text =  Text('Loading', style: TextStyles.weight400px14());
            break;
          case LoadStatus.noMore:
            text =  Text('End of Page.(', style: TextStyles.weight400px14());
            break;
          default:
            text = Text('Error', style: TextStyles.weight400px14());
        }
  
        return Container(
          height: 55.0,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(),
                SizedBox(width: 10),
                text
              ],
            )
          ),
        );
      },
    );
  }
}

