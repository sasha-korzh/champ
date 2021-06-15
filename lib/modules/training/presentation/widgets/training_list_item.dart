
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/modules/training/domain/entities/training.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrainingListItem extends StatelessWidget {
  final Training training;
  final ScreenUtil su = ScreenUtil();
  
  TrainingListItem({Key key, this.training}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: su.setWidth(315),
      // height: su.setHeight(125),
      child: Column(
        children: [
          getHeader(),
          getLikeAndTime()
        ],
      ),
    );
  }

  Widget getHeader() {
    return Container(
      child: Row(
        children: [
          Container(
            height: su.setWidth(79),
            width: su.setWidth(79),
            margin: EdgeInsets.only(right: su.setWidth(14)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                  image: NetworkImage(training.imageUrl)
              ),
            ),
          ),
          Container(
            width: su.setWidth(190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  training.author.fullname,
                  style: TextStyles.weight400px12(),
                ),
                SizedBox(height: su.setHeight(11)),
                Text(
                  training.title,
                  style: TextStyles.weight500px14(),
                ),
              ],
            ),
          ),
          Container(
            width: su.setWidth(18),
            height: su.setWidth(18),
            child: GestureDetector(
              child: Icon(Icons.bookmark_border, size: 20,),
              onTap: () {

              },
            ),
          )
        ],
      )
    );
  }

  Widget getLikeAndTime() {
    return Container(
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
}