
import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/no_glow_scroll_behavior.dart';
import 'package:champ/core/util/pages/app_pages.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/modules/home/home_controller.dart';
import 'package:champ/modules/post_feed/presentation/controllers/topic_controller.dart';
import 'package:champ/modules/post_feed/presentation/widgets/topic_list_item.dart';
import 'package:champ/modules/training/presentation/controllers/training_feed_controller.dart';
import 'package:champ/modules/training/presentation/widgets/training_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TopicPage extends StatelessWidget {
  final TopicController feedController = Get.find();
  final ScreenUtil su = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: Padding(
          padding: EdgeInsets.only(top: su.setHeight(24)),
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
                 final topic = feedController.topics[index];
                 return Container(
                   width: 1.0,
                   margin: EdgeInsets.only(bottom: su.setHeight(44)),
                   child: Center(child: TopicListItem(topic: topic)),
                 );
              },
              itemCount: feedController.topics.length,
            ),
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
            text = Text('Loading', style: TextStyles.weight400px14());
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