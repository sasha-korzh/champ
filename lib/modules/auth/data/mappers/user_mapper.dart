

import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/data/mappers/post_mapper.dart';
import 'package:get/get.dart';

class UserMapper {

  final PostMapper postMapper = Get.find();

  User userFromJson(Map<String, dynamic> jsonMap) {
    final topics = (jsonMap['topics']['items'] as List<dynamic>).map((e) {
      if (e != null) {
        return postMapper.topicInfoFromJson(e);
      }
    }).toList();
    final followers = (jsonMap['followers']['items'] as List<dynamic>).map((e) {
      if (e != null) {
        return userShortInfoFromJson(e);
      }
    }).toList();
    final following = (jsonMap['following']['items'] as List<dynamic>).map((e) {
      if (e != null) {
        return userShortInfoFromJson(e);
      }
    }).toList();

    return User(
      id: jsonMap['id'],
      fullname: jsonMap['fullname'],
      gender: getGender(jsonMap['gender']),
      avatarImageUrl: jsonMap['avatarImageUrl'],
      backgroundImageUrl: jsonMap['backgroundImageUrl'],
      topics: topics,
      followers: followers,
      followings: following,
      savedTraining: [],
    );
  }

  UserShortInfo userShortInfoFromJson(Map<String, dynamic> jsonMap) {
    return UserShortInfo(
      id: jsonMap['id'],
      fullname: jsonMap['fullname'],
      avatarImageUrl: jsonMap['avatarImageUrl'],
    );
  }

  Gender getGender(String type) {
    switch (type) {
      case 'woman':
        return Gender.woman;
      case 'man':
        return Gender.man;
      case 'other':
        return Gender.other;    
      default:
        return Gender.other;
    }
  }
}