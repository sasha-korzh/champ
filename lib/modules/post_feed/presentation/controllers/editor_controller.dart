
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditorController extends GetxController {
  final AuthController authController = Get.find();
  final selectedType = Rx<PostElementType>(PostElementType.text);
  final _nodes = RxList<FocusNode>();
  final _text = RxList<TextEditingController>();
  final _types = RxList<PostElementType>();
  final allTopics = RxList<TopicInfo>();

  int get length => _text.length;
  int get focus => _nodes.indexWhere((node) => node.hasFocus);
  FocusNode nodeAt(int index) => _nodes.elementAt(index);
  TextEditingController textAt(int index) => _text.elementAt(index);
  PostElementType typeAt(int index) => _types.elementAt(index);

  @override
  void onInit() {
    selectedType.value = PostElementType.text;
    allTopics.addAll(authController.currentUser.value.topics);
    insert(index: 0);
    super.onInit();
  }

  void setType(PostElementType type) {
    if (selectedType.value == type) {
      selectedType.value = PostElementType.text;
    } else {
      selectedType.value = type;
    }
    _types.removeAt(focus);
    _types.insert(focus, selectedType.value);
  }

  void setFocus(PostElementType type) {
    selectedType.value = type;
  }

  void insert({int index, String text, PostElementType type = PostElementType.text}) {
    final TextEditingController controller = TextEditingController(
      text: '\u200B' + (text ?? '')
    );
    controller.addListener(() {
      if (!controller.text.startsWith('\u200B')) {
        final int index = _text.indexOf(controller);
        if (index > 0) {
          textAt(index-1).text += controller.text;
          textAt(index-1).selection = TextSelection.fromPosition(TextPosition(
            offset: textAt(index-1).text.length - controller.text.length
          ));
          nodeAt(index-1).requestFocus();
          _text.removeAt(index);
          _nodes.removeAt(index);
          _types.removeAt(index);
        }
      }
      if(controller.text.contains('\n')) {
        final int index = _text.indexOf(controller);
        List<String> _split = controller.text.split('\n');
        controller.text = _split.first;
        insert(
          index: index+1,
          text: _split.last,
          type: typeAt(index) == PostElementType.bullet
            ? PostElementType.bullet
            : PostElementType.text
        );
        textAt(index+1).selection = TextSelection.fromPosition(
          TextPosition(offset: 1)
        );
        nodeAt(index+1).requestFocus();
      }
    });
    _text.insert(index, controller);
    _types.insert(index, type);
    _nodes.insert(index, FocusNode());
  }

}