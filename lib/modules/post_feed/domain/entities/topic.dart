
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:equatable/equatable.dart';

class Topic extends Equatable {
  final String id;
  final String name;
  final String description;
  final String avatarImageUrl;
  final String backgroundImageUrl;
  final List<Post> posts;
  final List<UserShortInfo> followers;

  Topic({this.id, this.name, this.description, this.avatarImageUrl, this.backgroundImageUrl, this.posts, this.followers});

  @override
  List<Object> get props => [id];
}

class TopicInfo extends Equatable {
  final String id;
  final String name;
  final String avatarImageUrl;

  TopicInfo({this.id, this.name, this.avatarImageUrl});

  @override
  List<Object> get props => [id];
}
