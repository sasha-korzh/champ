
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/training/domain/entities/training.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fullname;
  final Gender gender;
  final String avatarImageUrl;
  final String backgroundImageUrl;
  final List<Training> savedTraining;
  final List<UserShortInfo> followers;
  final List<UserShortInfo> followings;
  final List<TopicInfo> topics;

  User({
      this.id,
      this.fullname,
      this.gender,
      this.avatarImageUrl,
      this.backgroundImageUrl,
      this.savedTraining,
      this.followers,
      this.followings,
      this.topics,
      });

  @override
  List<Object> get props => [id];

  User copyWith({
    String id,
    String fullname,
    Gender gender,
    String avatarImageUrl,
    String backgroundImageUrl,
    List<Training> savedTraining,
    List<UserShortInfo> followers,
    List<UserShortInfo> followings,
    List<TopicInfo> topics,
  }) {
    return User(
      id: id ?? this.id,
      avatarImageUrl: avatarImageUrl ?? this.avatarImageUrl,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      fullname: fullname ?? this.fullname,
      gender: gender ?? this.gender,
      savedTraining: savedTraining ?? this.savedTraining,
      topics: topics ?? this.topics,
    );
  }
}

enum Gender {
  man,
  woman,
  other,
}