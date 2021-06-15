import 'package:champ/core/util/appColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screen_util_controller.dart';

class ScreenUtilInitPage extends GetView<ScreenUtilController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Container(
            height: 55.0,
            child: Center(child: CupertinoActivityIndicator()),
          ),
      )
    );
  }
}