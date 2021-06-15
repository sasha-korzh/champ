import 'package:champ/core/util/appColors.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EditorToolbar extends StatelessWidget {
  EditorToolbar({Key key, this.onSelected, this.selectedType}): super(key: key);

  final PostElementType selectedType;
  final ValueChanged<PostElementType> onSelected;
  ScreenUtil su = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: su.setHeight(50),
      child: Material(
        elevation: 15.0,
        color: AppColors.white,
        child: Row(
          children: <Widget>[
            SizedBox(width: su.setWidth(18)),
            GestureDetector(
              child: Container(
                width: su.setWidth(18),
                height: su.setWidth(18),
                child: selectedType == PostElementType.h1 ?
                    Image.asset('assets/icons/h1_selected.png')
                  :
                    Image.asset('assets/icons/h1.png')
              ),
              onTap: () => onSelected(PostElementType.h1)
            ),
            SizedBox(width: su.setWidth(18)),
            GestureDetector(
              child: Container(
                width: su.setWidth(18),
                height: su.setWidth(18),
                child: selectedType == PostElementType.h2 ?
                    Image.asset('assets/icons/h2_selected.png')
                  :
                    Image.asset('assets/icons/h2.png')
              ),
              onTap: () => onSelected(PostElementType.h2)
            ),
            SizedBox(width: su.setWidth(18)),
            GestureDetector(
              child: Container(
                width: su.setWidth(18),
                height: su.setWidth(18),
                child: selectedType == PostElementType.h3 ?
                    Image.asset('assets/icons/h3_selected.png')
                  :
                    Image.asset('assets/icons/h3.png')
              ),
              onTap: () => onSelected(PostElementType.h3)
            ),
            SizedBox(width: su.setWidth(18)),
            GestureDetector(
              child: Container(
                width: su.setWidth(18),
                height: su.setWidth(18),
                child: selectedType == PostElementType.image ?
                    Image.asset('assets/icons/image_selected.png')
                  :
                    Image.asset('assets/icons/image.png')
              ),
              onTap: () => onSelected(PostElementType.image)
            ),
            SizedBox(width: su.setWidth(18)),
            GestureDetector(
              child: Container(
                width: su.setWidth(18),
                height: su.setWidth(18),
                child: selectedType == PostElementType.link ?
                    Image.asset('assets/icons/link_selected.png')
                  :
                    Image.asset('assets/icons/link.png')
              ),
              onTap: () => onSelected(PostElementType.link)
            ),
          ]
        )
      ),
    );
  }
}