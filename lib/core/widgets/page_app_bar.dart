import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PageAppBar extends PreferredSize {
  final ScreenUtil screenUtil = ScreenUtil();
  final double height;
  final Color color;
  final String title;
  final Function onMorePressed;
  final IconData icon;

  PageAppBar({
    @required this.title,
    @required this.onMorePressed,
    this.height = 110,
    this.color = AppColors.white,
    this.icon = Icons.more_horiz,
  });

  @override
  Size get preferredSize => Size.fromHeight(screenUtil.setHeight(height));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: 18, color: AppColors.black),
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Get.back();
                  }
                ),
              ),
              Text(title, style: TextStyles.weight600px18()),
              Padding(
                padding: EdgeInsets.only(right: screenUtil.setWidth(10)),
                child: IconButton(
                  icon: Icon(icon, size: 18, color: AppColors.black),
                  padding: EdgeInsets.zero,
                  onPressed: onMorePressed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}