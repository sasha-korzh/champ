
import 'package:champ/core/util/appColors.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:champ/modules/post_feed/presentation/widgets/post_element_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostElementEditorView extends StatelessWidget {
  PostElementEditorView({Key key, this.type, this.controller, this.focusNode})
    : super(key: key);
  
  final PostElementType type;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ScreenUtil screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    if (type == PostElementType.image) {
      return Placeholder(
        fallbackHeight: screenUtil.setHeight(150),
        fallbackWidth: screenUtil.setWidth(150),
      );
    } else {
      return TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        cursorColor: AppColors.black,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixText: type.prefix,
          prefixStyle: type.textStyle,
          isDense: true,
          contentPadding: type.padding
        ),
        style: type.textStyle
      );
    }
  }
}