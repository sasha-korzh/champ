
import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/core/widgets/page_app_bar.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/training/domain/entities/training.dart';
import 'package:champ/modules/training/presentation/controllers/training_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TrainingPage extends StatelessWidget {
  ScreenUtil su = ScreenUtil();
  final TrainingController trainingController = Get.find();
  final Training training = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final topicAvatar = training.topic != null ? getTopicAvatar() : Container(); 
    final topicName = training.topic != null ? getTopicName() : Container();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PageAppBar(
        title: 'Тренировка',
        onMorePressed: () {

        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: su.setWidth(25)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    topicAvatar,
                    topicName,
                    Text(
                      training.author.fullname,
                      style: TextStyles.weight400px12(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    getTitleContent(training.title),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${training.createdAt.day} травня',
                    style: TextStyles.weight400px12(color: AppColors.blackLight),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: su.setWidth(350),
                height: su.setWidth(350),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: FractionalOffset.center,
                      image: NetworkImage(training.imageUrl)
                  ),
                ),
              ),
              getLikeAndTime(),
              SizedBox(height: 30),
              getTabBarSection()
            ],
          ),
        ),
      )
    );
  }

  
  Widget getTopicAvatar() {
    return Container(
      height: su.setHeight(18),
      width: su.setWidth(18),
      margin: EdgeInsets.only(right: su.setWidth(7)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        image: DecorationImage(
            fit: BoxFit.cover,
            alignment: FractionalOffset.center,
            image: NetworkImage(training.topic.avatarImageUrl)
        ),
      ),
    );
  }

  Widget getTopicName() {
    return Padding(
      padding: EdgeInsets.only(right: su.setWidth(7)),
      child: Text(
        training.topic.name,
        style: TextStyles.weight500px12(),
      ),
    );
  }

  Widget getTitleContent(String title) {
    return Container(
      margin: EdgeInsets.only(
        top: su.setHeight(11)
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: TextStyles.weight500px20())
      ),
    );
  }

  
  Widget getLikeAndTime() {
    return Container(
      width: su.setWidth(315),
      margin: EdgeInsets.only(
        top: su.setHeight(14),
        // bottom: su.setHeight(18)
      ),
      child: Row(
        children: [
          GestureDetector(
              child: Container(
                width: su.setWidth(18),
                height: su.setWidth(18),
                child: Image.asset('assets/icons/heart_outline.png'),
              ),
              onTap: () {
                // if (isLiked) {
                //   postController.unlikePost(post);
                // } else {
                //   postController.likePost(post);
                // }
              }
            ),
          SizedBox(width: su.setWidth(7)),
          Text(
            training.likesCount.toString(),
            style: TextStyles.weight400px12(),
          ),
          SizedBox(width: su.setWidth(14)),
          Container(
            width: su.setWidth(18),
            height: su.setWidth(18),
            child: Image.asset('assets/icons/clock.png'),
          ),
          SizedBox(width: su.setWidth(7)),
          Text(
            training.minutes.toString(),
            style: TextStyles.weight400px12(),
          ),
        ],
      ),
    );
  }

   Widget getTabBarSection() {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Container(
        height: 500,
        width: 1.0.sw,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: su.setHeight(45),
                padding: EdgeInsets.only(right: su.setWidth(70)),
                child: TabBar(
                  onTap: (index) {},
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: AppColors.grey,
                  ),
                  labelColor: AppColors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // indicatorPadding: EdgeInsets.all(10),
                  
                  tabs: [
                    Tab(text: 'Опис'),
                    Tab(text: 'Відгуки'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: su.setWidth(315),
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        training.description,
                        style: TextStyles.weight400px14(),
                      ),
                    ),
                  ),
                  getCommentSection()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getCommentSection() {
    final comments = training.comments.map((e) => toCommentWidget(e)).toList();
    if (comments.length == 0) {
      return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: su.setHeight(40)),
          child: Text(
            'Нету комментариев',
            style: TextStyles.weight600px18(color: AppColors.greyDark),
          ),
        ),
      );
    } 
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: su.setHeight(20)),
          Padding(
            padding: EdgeInsets.only(left: su.setWidth(10)),
            child: Text(
              'Комментарии',
              style: TextStyles.weight600px18(),
            ),
          ),
          SizedBox(height: su.setHeight(20)),
          Container(
            child: Column(
              children: comments,
            ),
          ),
        ],
      ),
    );
  }
    
  Widget toCommentWidget(Comment e) {
    return Container(
      margin: EdgeInsets.only(bottom: su.setHeight(20)),
      height: su.setHeight(60),
      child: Row(
        children: [
          Container(
            width: su.setWidth(30),
            height: su.setWidth(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                  image: NetworkImage(e.author.avatarImageUrl)
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Text(
                        e.author.fullname,
                        style: TextStyles.weight500px12(),
                      ),
                      Text(
                        e.createdAt.toString(),
                        style: TextStyles.weight400px12(),
                      )
                    ]
                  )
                ),
                Text(
                  e.text,
                  style: TextStyles.weight400px14(),
                )
              ]
            )
          )
        ],
      ),
    );
  }
}