import 'package:champ/core/util/textStyles.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:flutter/material.dart';

extension PostElementStyle on PostElementType {
  TextStyle get textStyle {
    switch (this) {
      case PostElementType.link:
        return TextStyles.linkStyle();
      case PostElementType.bullet:
        return TextStyles.weight400px12();
      case PostElementType.h3:
      case PostElementType.h2:
      case PostElementType.h1:
        return TextStyles.weight600px18();
      default:
        return TextStyles.weight400px14();
    }
  }
  
  EdgeInsets get padding {
    switch (this) {
      case PostElementType.h3:
      case PostElementType.h2:
      case PostElementType.h1:
        return EdgeInsets.fromLTRB(0, 12, 0, 12);
        break;
      case PostElementType.bullet:
      case PostElementType.link:
        return EdgeInsets.fromLTRB(0, 8, 0, 8);
      default:
        return EdgeInsets.fromLTRB(0, 8, 0, 8);
    }
  }

  String get prefix {
    switch (this) {
      case PostElementType.bullet:
        return '\u2022 ';
      default:
    }
  }
}