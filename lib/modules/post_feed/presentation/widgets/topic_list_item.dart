
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/training/domain/entities/training.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TopicListItem extends StatelessWidget {
  final Topic topic;
  final ScreenUtil su = ScreenUtil();
  final AuthController authController = Get.find();
  
  TopicListItem({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: su.setWidth(315),
      child: Column(
        children: [
          getHeader(),
        ],
      ),
    );
  }

  Widget getHeader() {
    return Container(
      width: su.setWidth(315),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: su.setWidth(54),
            width: su.setWidth(54),
            margin: EdgeInsets.only(right: su.setWidth(14)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                  image: NetworkImage(topic.avatarImageUrl)
              ),
            ),
          ),
          Container(
            width: su.setWidth(220),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic.name,
                  style: TextStyles.weight500px14(),
                ),
                SizedBox(height: su.setHeight(11)),
                Text(
                  '${topic.followers.length} подписчиков',
                  style: TextStyles.weight400px12(),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: su.setWidth(18),
              height: su.setWidth(18),
              child: Obx(() => GestureDetector(
                child: Icon(
                  authController.currentUser.value.topics.any((e) => e.id == topic.id) ?
                    Icons.check
                  :
                    Icons.add,
                 size: 20,),
                onTap: () {
                  authController.currentUser.update((val) {
                    val.topics.add(TopicInfo(
                      id: topic.id,
                      name: topic.name,
                      avatarImageUrl: topic.avatarImageUrl
                    ));
                  });
                },
              ),)
            ),
          )
        ],
      )
    );
  }
}