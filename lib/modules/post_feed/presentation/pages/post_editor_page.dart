
import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/pages/app_pages.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/core/widgets/page_app_bar.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/post_feed/presentation/controllers/editor_controller.dart';
import 'package:champ/modules/post_feed/presentation/controllers/post_controller.dart';
import 'package:champ/modules/post_feed/presentation/widgets/editor_toolbar.dart';
import 'package:champ/modules/post_feed/presentation/widgets/post_element_editor_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class Pair<T, W> {
  final T left;
  final W right;

  Pair(this.left, this.right);
}

class PostEditorPage extends StatefulWidget {
  PostEditorPage({Key key}) : super(key: key);

  @override
  _PostEditorPageState createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  final EditorController editorController = Get.find();
  final images = RxList<Pair<int, String>>([]);
  final PostController postController = Get.find();
  bool showToolbar = false;
  final loadState = Rx<bool>(false);
  final currentTopic = Rx<TopicInfo>();
  ScreenUtil su = ScreenUtil();

  @override
  void initState() { 
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (isVisible) {
        if (!isVisible) {
          FocusScope.of(context).unfocus();
        }
        setState(() {
          showToolbar = isVisible;
        });
      },
    );
  }

  @override
  void dispose() { 
    KeyboardVisibilityNotification().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (loadState.value) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Center(
            child: Container(
                height: 55.0,
                child: Center(child: CupertinoActivityIndicator()),
              ),
          )
        );
      } else {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: PageAppBar(
              title: 'Создание поста',
              icon: Icons.check,
              onMorePressed: () async {
                loadState.value = true;
                final post = await postController.createPost(currentTopic.value);
                Get.offAndToNamed(Routes.postPage, arguments: post);
              },
            ),
            body: Stack(
              children: [
                Obx(() {
                  final length = editorController.length + images.length;
                  var counter = 0;
                  final topicsButtons = editorController.allTopics.map((e) => 
                    Row(
                      children: [
                        getTopicAvatar(e),
                        getTopicName(e)
                      ],
                    )
                  ).toList();
                  
                  return Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    bottom: 56,
                    child: Obx(() {
                      print('LIST:  ------------------- editorController.length: ${editorController.length}');
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: 27),
                              child: PopupMenuButton(
                                child: Obx(() {
                                  final text = currentTopic.value == null ? 'Виберіть тему...' : currentTopic.value.name;
                                  return Text(
                                    text,
                                    style: TextStyles.weight500px14(color: AppColors.black.withOpacity(0.5)),
                                  );
                                }),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                                onSelected: (index) {
                                  currentTopic.value = editorController.allTopics[index];
                                },
                                elevation: 30,
                                itemBuilder: (context) {
                                  return List.generate(topicsButtons.length, (index) {
                                    return PopupMenuItem(
                                      value: index,
                                      child: topicsButtons[index],
                                    );
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: editorController.length + images.length,
                              itemBuilder: (context, index) {

                                if (images.isNotEmpty && counter < images.length) {
                                  if (index == images[counter].left) {
                                    counter++;
                                    if (index == (editorController.length + images.length)) {
                                      counter = 0;
                                    }
                                    return Placeholder(
                                      fallbackHeight: 150,
                                      fallbackWidth: 150,
                                    );
                                  }
                                }
                                
                                print('LIST: index: $index');
                                // if (index >= editorController.length) {
                                //   return Container();
                                // }
                                
                                return Obx(() => Focus(
                                  onFocusChange: (hasFocus) {
                                    if (hasFocus) editorController.setFocus(editorController.typeAt(index - counter));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 27.0),
                                    child: PostElementEditorView(
                                      type: editorController.typeAt(index - counter),
                                      controller: editorController.textAt(index - counter),
                                      focusNode: editorController.nodeAt(index - counter),
                                    ),
                                  )
                                ));
                              }
                            ),
                          ),
                        ],
                      );
                    })
                  );
                }),
                if (showToolbar) Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Obx(() => EditorToolbar(
                    selectedType: editorController.selectedType.value,
                    onSelected: (postElementType) {
                      if (postElementType != PostElementType.image) {
                        editorController.setType(postElementType);
                      } else {
                        images.add(Pair(editorController.length + images.length, ''));
                        // editorController.setType(PostElementType.text);
                      }
                    },
                  )),
                )
              ],
            )
          ),
        );
      }
    });
  }

  Widget getTopicAvatar(TopicInfo topicInfo) {
    return Container(
      height: su.setHeight(18),
      width: su.setWidth(18),
      margin: EdgeInsets.only(right: su.setWidth(7)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        image: DecorationImage(
            fit: BoxFit.cover,
            alignment: FractionalOffset.center,
            image: NetworkImage(topicInfo.avatarImageUrl)
        ),
      ),
    );
  }

  Widget getTopicName(TopicInfo topicInfo) {
    return Padding(
      padding: EdgeInsets.only(right: su.setWidth(7)),
      child: Text(
        topicInfo.name,
        style: TextStyles.weight500px12(),
      ),
    );
  }
}