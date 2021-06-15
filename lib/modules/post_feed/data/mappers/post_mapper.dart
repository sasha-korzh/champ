import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:champ/modules/post_feed/domain/entities/post_page.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';

class PostMapper {

  PostPage postPageFromJson(Map<String, dynamic> jsonMap) {
    final items = (jsonMap['items'] as List<dynamic>).map((e) {
      if (e != null) {
        return postFromJson(e);
      }
    }).toList();

    return PostPage(
      count: jsonMap['count'],
      lastEvaluatedKey: jsonMap['lastEvaluatedKey'],
      items: items,
    );
  }

  Post postFromJson(Map<String, dynamic> jsonMap) {
    final postElements = (jsonMap['postElements']['items'] as List<dynamic>).map((e) {
      if (e != null) {
        return postElementFromJson(e);
      }
    }).toList();
    final comments = (jsonMap['comments']['items'] as List<dynamic>).map((e) {
      if (e != null) {
        return commentFromJson(e);
      }
    }).toList();

    return Post(
      id: jsonMap['id'],
      createdAt: DateTime.parse(jsonMap['createdAt']),
      topicInfo: jsonMap['topic'] == null ? null : topicInfoFromJson(jsonMap['topic']),
      author: userShortInfoFromJson(jsonMap['author']),
      comments: comments,
      likesCount: jsonMap['likesCount'],
      postElements: postElements,
    );
  }

  UserShortInfo userShortInfoFromJson(Map<String, dynamic> jsonMap) {
    return UserShortInfo(
      id: jsonMap['id'],
      fullname: jsonMap['fullname'],
      avatarImageUrl: jsonMap['avatarImageUrl'],
    );
  }

  TopicInfo topicInfoFromJson(Map<String, dynamic> jsonMap) {
    return TopicInfo(
      id: jsonMap['id'],
      name: jsonMap['name'],
      avatarImageUrl: jsonMap['avatarImageUrl']
    );
  }

  PostElement postElementFromJson(Map<String, dynamic> jsonMap) {
    final elementType = jsonMap['type'];
    return PostElement(
      id: jsonMap['id'],
      type: getPostElementType(elementType),
      data: jsonMap['data']
    );
  }

  Comment commentFromJson(Map<String, dynamic> jsonMap) {
    return Comment(
      id: jsonMap['id'],
      author: userShortInfoFromJson(jsonMap['owner']),
      createdAt: DateTime.parse(jsonMap['createdAt']),
      text: jsonMap['text'],
    );
  }

  PostElementType getPostElementType(String type) {
    switch (type) {
      case 'link':
        return PostElementType.link;
      case 'bullet':
        return PostElementType.bullet;
      case 'video':
        return PostElementType.video;
      case 'image':
        return PostElementType.image;
      case 'text':
        return PostElementType.text;      
      case 'h1':
        return PostElementType.h1;      
      case 'h2':
        return PostElementType.h2;      
      case 'h3':
        return PostElementType.h3;      
      default:
        return PostElementType.text;
    }
  }
}