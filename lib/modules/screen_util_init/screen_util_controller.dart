
import 'dart:ui';

import 'package:champ/core/util/pages/app_pages.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScreenUtilController extends GetxController {
  @override
  void onReady() {
    ScreenUtil.init(Get.context, designSize: Size(375, 812), allowFontScaling: true);
    Get.offNamed(Routes.home);
    super.onReady();
  }
}