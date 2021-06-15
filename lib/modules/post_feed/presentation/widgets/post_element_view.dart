import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:champ/modules/post_feed/presentation/widgets/post_element_style.dart';

class PostElementView extends StatelessWidget {
  PostElementView({Key key, this.postElement})
    : super(key: key);
  
  final PostElement postElement;
  final ScreenUtil screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {

    if (postElement.type == PostElementType.image) {
      return Placeholder(
        fallbackHeight: screenUtil.setHeight(200),
        fallbackWidth: screenUtil.setWidth(150),
      );
    } else if (postElement.type == PostElementType.video) {
      return Placeholder(
        fallbackHeight: screenUtil.setHeight(200),
        fallbackWidth: screenUtil.setWidth(150),
      );
    } else {
      return Padding(
        padding: postElement.type.padding,
        child: Text(
          postElement.data,
          style: postElement.type.textStyle
        ),
      );
    }
  }
}