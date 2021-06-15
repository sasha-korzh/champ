
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'appColors.dart';

class TextStyles {
  TextStyles._();

  static TextStyle weight600px25({color: AppColors.black}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w600,
      fontSize: 25.ssp,
    );
  }

  static TextStyle weight600px18({color: AppColors.black}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w600,
      fontFamily: 'FiraSans',
      fontSize: 18.ssp,
    );
  }

  static TextStyle weight500px20() {
    return TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w500,
      fontFamily: 'FiraSans',
      fontSize: 20.ssp,
    );
  }

  static TextStyle weight500px16() {
    return TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w500,
      fontFamily: 'FiraSans',
      fontSize: 16.ssp,
    );
  }

  static TextStyle weight500px12() {
    return TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w500,
      fontFamily: 'FiraSans',
      fontSize: 12.ssp,
    );
  }

  static TextStyle weight500px14({color: AppColors.black}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w500,
      fontFamily: 'FiraSans',
      fontSize: 14.ssp,
    );
  }

  static TextStyle weight400px14() {
    return TextStyle(
      color: AppColors.black,
      fontWeight: FontWeight.w400,
      fontFamily: 'FiraSans',
      fontSize: 14.ssp,
    );
  }

  static TextStyle weight400px12({color: AppColors.black}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w400,
      fontFamily: 'FiraSans',
      fontSize: 12.ssp,
    );
  }

  static TextStyle weight600px12() {
    return TextStyle(
      color: AppColors.grey,
      fontWeight: FontWeight.w600,
      fontFamily: 'FiraSans',
      fontSize: 12.ssp,
    );
  }

  static TextStyle weight600px14({color: AppColors.grey}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w600,
      fontFamily: 'FiraSans',
      fontSize: 14.ssp,
    );
  }

  static TextStyle linkStyle() {
    return TextStyle(
      color: AppColors.blue,
      fontWeight: FontWeight.w400,
      fontFamily: 'FiraSans',
      fontSize: 14.ssp,
    );
  }

}