

import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/core/widgets/page_app_bar.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/training/presentation/controllers/training_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreateTrainingPage extends StatefulWidget {

  @override
  _CreateTrainingPageState createState() => _CreateTrainingPageState();
}

class _CreateTrainingPageState extends State<CreateTrainingPage> {
  
  ScreenUtil su = ScreenUtil();
  final TrainingController trainingController = Get.find();
  final AuthController authController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final currentTopic = Rx<TopicInfo>();

  final hasTitle = Rx<bool>(false);
  final hasPhotoStream = Rx<bool>(false);
  final hasTopicStream = Rx<bool>(false);
  final hasDescription = Rx<bool>(false);
  final hasTime = Rx<bool>(false);
  final hasVideo = Rx<bool>(false);

  final loadState = Rx<bool>(false);

  @override
  void initState() {
    titleController.addListener(() {
        hasTitle.value = titleController.text.isNotEmpty;
    });
    descController.addListener(() {
        hasDescription.value = descController.text.isNotEmpty;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final topicsButtons = authController.currentUser.value.topics.map((e) => 
      Row(
        children: [
          getTopicAvatar(e),
          getTopicName(e)
        ],
      )
    ).toList();


    return Obx(() {
      if (loadState.value) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Center(
            child: Container(
                height: 55.0,
                child: Center(child: CupertinoActivityIndicator()),
              ),
          )
        );
      } else {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: PageAppBar(
            title: 'Створення тренування',
            icon: Icons.check,
            onMorePressed: () async {
              loadState.value = true;
              final training = await trainingController.createTraining(
                
              );
              Get.offAndToNamed(Routes.trainingPage, arguments: training);
            },
          ),
          resizeToAvoidBottomPadding: false,
          body: Container(
            height: 1.0.sh,
            width: 1.0.sw,
            child:  Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 27),
                  child: Row(
                    children: [
                      Obx(() => Container(
                        width: su.setWidth(24),
                        height: su.setWidth(24),
                        child: Image.asset(
                          hasTitle.value ?
                          'assets/icons/h1_selected.png'
                          :
                          'assets/icons/heading_h1_light.png'
                        ),
                      ),),
                      SizedBox(width: 10,),
                      Expanded(child: title())
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 27),
                  child: staticItem(
                    iconPath: hasPhotoStream.value ? 'assets/icons/file_new_selected.png' : 'assets/icons/file_new.png',
                    text: 'Завантажити головне фото',
                    isActive: hasPhotoStream.value,
                    onPressed: () {
                      hasPhotoStream.value = true;
                    }
                  ),
                ),
                SizedBox(height: 21),
                PopupMenuButton(
                  child: Obx(() {
                    final text = currentTopic.value == null ? 'Виберіть тему...' : currentTopic.value.name;

                    return Padding(
                        padding: EdgeInsets.only(left: 27),
                        child: staticItemWithoutPress(
                        iconPath: currentTopic.value != null ? 'assets/icons/list_checklist.png' : 'assets/icons/list_checklist_light.png',
                        text: text,
                        isActive: currentTopic.value != null,
                      ),
                    );
                  }),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  onSelected: (index) {
                    currentTopic.value = authController.currentUser.value.topics[index];
                  },
                  elevation: 30,
                  itemBuilder: (context) {
                    return List.generate(topicsButtons.length, (index) {
                      return PopupMenuItem(
                        value: index,
                        child: topicsButtons[index],
                      );
                    });
                  },
                ),
                SizedBox(height: 7),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 27),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() => Container(
                        width: su.setWidth(24),
                        height: su.setWidth(24),
                        child: Image.asset(
                          hasDescription.value ? 
                            'assets/icons/text_align_center_selected.png'
                          :
                            'assets/icons/text_align_center.png'
                        ),
                      ),),
                      SizedBox(width: 10,),
                      Expanded(child: description())
                    ],
                  ),
                ),
                SizedBox(height: 60),
                Container(
                  color: AppColors.grey,
                  width: 1.0.sw,
                  height: su.setHeight(8),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(left: 27),
                  child: staticItem(
                  iconPath: hasTime.value ? 'assets/icons/clock.png' : 'assets/icons/clock_light.png',
                  text: 'Встановити час',
                  isActive: hasTime.value,
                  onPressed: () {
                    hasTime.value = true;
                  }
                ),
                ),
                SizedBox(height: 13),
                Padding(
                  padding: EdgeInsets.only(left: 27),
                  child: staticItem(
                  iconPath: hasVideo.value ? 'assets/icons/file_new_selected.png' : 'assets/icons/file_new.png',
                  text: 'Завантажити відео',
                  isActive: hasVideo.value,
                  onPressed: () {
                    hasVideo.value = true;
                  }
                ),
                ),
              ],
            ),
          )
        );
      }
    });
  }

  Widget title() {
    return Container(
      child: TextField(
        style: TextStyles.weight500px14(),
        cursorWidth: 1.5,
        cursorColor: AppColors.black,
        controller: titleController,
        keyboardType: TextInputType.multiline,
        scrollPadding: EdgeInsets.zero,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.white,
              width: 1.0
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.white,
              width: 1.0
            ),
          ),
          hintText: 'Назва тренування...',
          hintStyle: TextStyles.weight600px14(color: AppColors.blackLight),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      child: TextField(
        style: TextStyles.weight500px14(),
        cursorWidth: 1.5,
        controller: descController,
        cursorColor: AppColors.black,
        keyboardType: TextInputType.multiline,
        scrollPadding: EdgeInsets.zero,
        // maxLines: 3,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.white,
              width: 1.0
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.white,
              width: 1.0
            ),
          ),
          hintText: 'Текст опису...',
          hintStyle: TextStyles.weight600px14(color: AppColors.blackLight),
        ),
      ),
    );
  }

  staticItem({String iconPath, String text, bool isActive,Function() onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 1.0.sw,
        height: 24,
        child: Row(
          children: [
            Container(
              width: su.setWidth(24),
              height: su.setWidth(24),
              child: Image.asset(iconPath),
            ),
            SizedBox(width: 10,),
            Text(
              text,
              style: TextStyles.weight600px14(color: isActive ? AppColors.black : AppColors.blackLight),
            )
          ],
        ),
      ),
    );
  }

  staticItemWithoutPress({String iconPath, String text, bool isActive,}) {
    return Container(
      width: 1.0.sw,
      height: 24,
      child: Row(
        children: [
          Container(
            width: su.setWidth(24),
            height: su.setWidth(24),
            child: Image.asset(iconPath),
          ),
          SizedBox(width: 10,),
          Text(
            text,
            style: TextStyles.weight600px14(color: isActive ? AppColors.black : AppColors.blackLight),
          )
        ],
      ),
    );
  }

  Widget getTopicAvatar(TopicInfo topicInfo) {
    return Container(
      height: su.setHeight(18),
      width: su.setWidth(18),
      margin: EdgeInsets.only(right: su.setWidth(7)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        image: DecorationImage(
            fit: BoxFit.cover,
            alignment: FractionalOffset.center,
            image: NetworkImage(topicInfo.avatarImageUrl)
        ),
      ),
    );
  }

  Widget getTopicName(TopicInfo topicInfo) {
    return Padding(
      padding: EdgeInsets.only(right: su.setWidth(7)),
      child: Text(
        topicInfo.name,
        style: TextStyles.weight500px12(),
      ),
    );
  }
  
}