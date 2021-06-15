
import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/core/widgets/page_app_bar.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:champ/modules/post_feed/presentation/controllers/post_controller.dart';
import 'package:champ/modules/post_feed/presentation/widgets/post_element_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PostPage extends StatelessWidget {
  ScreenUtil su = ScreenUtil();
  final PostController postController = Get.find();
  final AuthController authController = Get.find();
  final Post post = Get.arguments;
  final TextEditingController textEditingController = TextEditingController();
  final comments = RxList<Comment>();

  @override
  Widget build(BuildContext context) {
    final topicAvatar = post.topicInfo != null ? getTopicAvatar() : Container(); 
    final topicName = post.topicInfo != null ? getTopicName() : Container(); 
    final titleContent = hasTitleToShow();
    comments.addAll(post.comments);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PageAppBar(
        title: 'Пост',
        onMorePressed: () {

        },
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: su.setWidth(25)),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  topicAvatar,
                  topicName,
                  Text(
                    post.author.fullname,
                    style: TextStyles.weight400px12(),
                  ),
                ],
              ),
            ),
            if (titleContent == null) 
              Container()
            else
              Container(
                child: Column(
                  children: [
                    getTitleContent(titleContent.data),
                    getButtonsBar(),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: post.postElements.length + 1,
                itemBuilder: (context, index) {
                  if (titleContent != null && index == 0) {
                    return Container();
                  } else if (index == post.postElements.length) {
                    return Container(
                      margin: EdgeInsets.only(top: 50),
                      child: getCommentSection()
                      );
                  }
                  return PostElementView(postElement: post.postElements[index]);
                }
              ),
            ),
          ],
        ),
      )
    );
  }

  PostElement hasTitleToShow() {
    final range = post.postElements.length < 4 ? post.postElements.length : 4;
    return post.postElements.getRange(0, range).firstWhere((e) => e.type == PostElementType.h1, orElse: () => null);
  }

  PostElement hasTextToShow() {
    final range = post.postElements.length < 3 ? post.postElements.length : 3;
    return post.postElements.getRange(0, range).firstWhere((e) => e.type == PostElementType.text, orElse: () => null);
  }

  PostElement hasImageToShow() {
    final range = post.postElements.length < 4 ? post.postElements.length : 4;
    return post.postElements.getRange(0, range).firstWhere((e) => e.type == PostElementType.image, orElse: () => null);
  }

  Widget getTopicAvatar() {
    return Container(
      height: su.setHeight(18),
      width: su.setWidth(18),
      margin: EdgeInsets.only(right: su.setWidth(7)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        image: DecorationImage(
            fit: BoxFit.cover,
            alignment: FractionalOffset.center,
            image: NetworkImage(post.topicInfo.avatarImageUrl)
        ),
      ),
    );
  }

  Widget getTopicName() {
    return Padding(
      padding: EdgeInsets.only(right: su.setWidth(7)),
      child: Text(
        post.topicInfo.name,
        style: TextStyles.weight500px12(),
      ),
    );
  }

  Widget getTitleContent(String title) {
    return Container(
      margin: EdgeInsets.only(
        top: su.setHeight(11)
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: TextStyles.weight500px20())
      ),
    );
  }

  Widget getTextContent(String text) {
    if (text.length > 80) {
      text = text.substring(0, 80);
      text += ' ...';
    }
    
    return Container(
      margin: EdgeInsets.only(
        top: su.setHeight(11)
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: TextStyles.weight400px14())
      ),
    );
  }

  Widget getImageContent(String url) {
    return Container(
      margin: EdgeInsets.only(
        top: su.setHeight(11)
      ),
      height: su.setHeight(200),
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            alignment: FractionalOffset.center,
            image: NetworkImage(url)
        ),
      ),
    );
  }

   Widget getButtonsBar() {
    return Container(
      margin: EdgeInsets.only(
        top: su.setHeight(11),
        bottom: su.setHeight(11)
      ),
      child: Container(
        child: Row(
          children: [
            Obx(() {
              final isLiked = postController.likedPostsIds.contains(post.id);
              return GestureDetector(
                child: isLiked ? 
                  Icon(Icons.favorite)
                  :
                  Icon(Icons.favorite_border),
                onTap: () {
                  if (isLiked) {
                    print('LIKES: unlike');
                    postController.unlikePost(post);
                  } else {
                    print('LIKES: like');
                    postController.likePost(post);
                  }
                }
              );
            }),
            SizedBox(width: su.setWidth(7)),
            Text(
              post.likesCount.toString(),
              style: TextStyles.weight400px12(),
            ),
            SizedBox(width: su.setWidth(20)),
            GestureDetector(
              child: Icon(Icons.bookmark_border),
              onTap: () {
                
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getCommentSection() {
    return Obx(() {
      final widgetComments = comments.map((e) => toCommentWidget(e)).toList();
    if (widgetComments.length == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
          padding: EdgeInsets.only(left: su.setWidth(10)),
          child: Text(
            'Комментарии',
            style: TextStyles.weight600px18(),
          ),
        ),
        SizedBox(height: su.setHeight(20)),
          Container(
            child: Row(
              children: [
                Container(
                  width: su.setWidth(280),
                  child: TextField(
                    style: TextStyles.weight500px14(),
                    cursorWidth: 1.5,
                    controller: textEditingController,
                    keyboardType: TextInputType.multiline,
                    scrollPadding: EdgeInsets.zero,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.black,
                          width: 1.0
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.black,
                          width: 1.0
                        ),
                      ),
                      hintText: 'Ваш коментар...',
                      hintStyle: TextStyles.weight500px14(color: AppColors.greyDark),
                    ),
                  ),
                ),
                SizedBox(width: su.setWidth(10)),
                Container(
                  width: su.setWidth(22),
                  height: su.setWidth(22),
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: AppColors.greyDark,
                    borderRadius: BorderRadius.circular(3)
                  ),
                  child: GestureDetector(
                    child: Image.asset('assets/icons/short_right.png'),
                    onTap: () {
                      comments.add(Comment(
                        id: DateTime.now().microsecond.toString(),
                        createdAt: DateTime.now(),
                        text: textEditingController.text,
                        author: UserShortInfo(
                          id: authController.currentUser.value.id,
                          avatarImageUrl: authController.currentUser.value.avatarImageUrl,
                          fullname: authController.currentUser.value.fullname
                        )
                      ));
                      textEditingController.text = '';
                    },
                  ),
                )
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: su.setHeight(50)),
              child: Text(
                'Нету комментариев',
                style: TextStyles.weight600px18(color: AppColors.greyDark),
              ),
            ),
          ),
        ],
      );
    } 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: su.setWidth(10)),
          child: Text(
            'Комментарии',
            style: TextStyles.weight600px18(),
          ),
        ),
        SizedBox(height: su.setHeight(20)),
        Container(
        child: Row(
          children: [
        Container(
          width: su.setWidth(280),
          child: TextField(
            style: TextStyles.weight500px14(),
            cursorWidth: 1.5,
            controller: textEditingController,
            keyboardType: TextInputType.multiline,
            scrollPadding: EdgeInsets.zero,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.black,
                  width: 1.0
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.black,
                  width: 1.0
                ),
              ),
              hintText: 'Ваш коментар...',
              hintStyle: TextStyles.weight500px14(color: AppColors.greyDark),
            ),
          ),
        ),
        SizedBox(width: su.setWidth(10)),
        Container(
          width: su.setWidth(22),
          height: su.setWidth(22),
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: AppColors.greyDark,
            borderRadius: BorderRadius.circular(3)
          ),
          child: GestureDetector(
            child: Image.asset('assets/icons/short_right.png'),
            onTap: () {
              comments.add(Comment(
                id: DateTime.now().microsecond.toString(),
                createdAt: DateTime.now(),
                text: textEditingController.text,
                author: UserShortInfo(
                  id: authController.currentUser.value.id,
                  avatarImageUrl: authController.currentUser.value.avatarImageUrl,
                  fullname: authController.currentUser.value.fullname
                )
              ));
              textEditingController.text = '';
            },
          ),
        )
          ],
        ),
          ),
        SizedBox(height: su.setHeight(20)),
        SizedBox(height: su.setHeight(20)),
        Container(
          child: Column(
            children: widgetComments,
          ),
        ),
      ],
    );
    });
  }
    
  Widget toCommentWidget(Comment e) {
    final authorName = e.author.fullname.length > 12 ? e.author.fullname.substring(0, 12) + '...' : e.author.fullname;
    return Container(
      margin: EdgeInsets.only(bottom: su.setHeight(20)),
      // height: su.setHeight(60),
      width: su.setWidth(320),
      child: Row(
        children: [
          Container(
            width: su.setWidth(30),
            height: su.setWidth(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: FractionalOffset.center,
                  image: NetworkImage(e.author.avatarImageUrl)
              ),
            ),
          ),
          SizedBox(width: su.setWidth(10)),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: su.setWidth(260),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        authorName,
                        style: TextStyles.weight500px12(),
                      ),
                      Text(
                        '${e.createdAt.day.toString()}.${e.createdAt.month.toString()}.${e.createdAt.year.toString()}',
                        style: TextStyles.weight400px12(),
                      )
                    ]
                  )
                ),
                Text(
                  e.text,
                  style: TextStyles.weight400px14(),
                )
              ]
            )
          )
        ],
      ),
    );
  }
}