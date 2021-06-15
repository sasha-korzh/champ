import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:champ/modules/post_feed/presentation/controllers/feed_controller.dart';
import 'package:champ/modules/post_feed/presentation/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostListItem extends StatelessWidget {
  PostListItem({
    Key key,
    @required this.post,
  }) : super(key: key);

  final FeedController feedController = Get.find();
  final PostController postController = Get.find();
  final Post post;
  final likesCount = Rx<int>(0);

  @override
  Widget build(BuildContext context) {
    likesCount.value = post.likesCount;
    final topicAvatar = post.topicInfo != null ? getTopicAvatar() : Container(); 
    final topicName = post.topicInfo != null ? getTopicName() : Container(); 
    final titleContent = hasTitleToShow();
    final textContent = hasTextToShow();
    final imageContent = hasImageToShow();

    return Center(
      child: Container(
        width: feedController.screenUtil.setWidth(315),
        padding: EdgeInsets.only(top: feedController.screenUtil.setHeight(18)),
        color: AppColors.white,
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
            titleContent != null ? getTitleContent(titleContent.data) : Container(),
            textContent != null ? getTextContent(textContent.data) : Container(),
            imageContent != null ? getImageContent(imageContent.data) : Container(),
            getButtonsBar()
          ],
        ),
      ),
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
      height: feedController.screenUtil.setHeight(18),
      width: feedController.screenUtil.setWidth(18),
      margin: EdgeInsets.only(right: feedController.screenUtil.setWidth(7)),
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
      padding: EdgeInsets.only(right: feedController.screenUtil.setWidth(7)),
      child: Text(
        post.topicInfo.name,
        style: TextStyles.weight500px12(),
      ),
    );
  }

  Widget getTitleContent(String title) {
    return Container(
      margin: EdgeInsets.only(
        top: feedController.screenUtil.setHeight(11)
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
        top: feedController.screenUtil.setHeight(11)
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
        top: feedController.screenUtil.setHeight(11)
      ),
      height: feedController.screenUtil.setHeight(200),
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
        top: feedController.screenUtil.setHeight(11),
        bottom: feedController.screenUtil.setHeight(18)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Obx(() {
                  final isLiked = postController.likedPostsIds.contains(post.id);
                  print('IS LIKED: $isLiked');
                  return GestureDetector(
                    child: isLiked ? 
                      Icon(Icons.favorite)
                      :
                      Icon(Icons.favorite_border),
                    onTap: () async {
                      var likes;
                      if (isLiked) {
                        print('LIKES: unlike');
                        likes = await postController.unlikePost(post);
                      } else {
                        print('LIKES: like');
                        likes = await postController.likePost(post);
                      }
                      print('LIKES: likes: $likes');
                      likesCount.value = likes;
                    }
                  );
                }),
                SizedBox(width: feedController.screenUtil.setWidth(7)),
                Obx(() => Text(
                  likesCount.value.toString(),
                  style: TextStyles.weight400px12(),
                )),
                SizedBox(width: feedController.screenUtil.setWidth(20)),
                GestureDetector(
                  child: Icon(Icons.bookmark_border),
                  onTap: () {

                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            child: Icon(Icons.more_horiz),
            onTap: () {

            }
          ),
        ],
      ),
    );
  }
}