import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SlidableAppBar extends PreferredSize {
  final ScreenUtil screenUtil = ScreenUtil();
  final double height;
  final Animation<Offset> position;
  final Color color;
  final String title;
  final Widget leftButton;
  final Widget rightButton;


  SlidableAppBar({
    @required this.title,
    @required this.leftButton,
    this.height = 110,
    this.position,
    this.rightButton,
    this.color = AppColors.white,
  });

  @override
  Size get preferredSize => Size.fromHeight(screenUtil.setHeight(height));

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: position,
      child: SafeArea(
        child: Center(
          child: Container(
            height: height,
            width: 1.0.sw,
            color: color,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenUtil.setWidth(10)),
                  child: leftButton
                ),
                Text(title, style: TextStyles.weight600px18()),
                Padding(
                  padding: EdgeInsets.only(right: screenUtil.setWidth(10)),
                  child: rightButton
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}