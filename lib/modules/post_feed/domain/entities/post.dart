import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final UserShortInfo author;
  final TopicInfo topicInfo;
  final DateTime createdAt;
  int likesCount;
  final List<PostElement> postElements;
  final List<Comment> comments;

  Post(
      {this.id,
      this.author,
      this.likesCount,
      this.topicInfo,
      this.createdAt,
      this.postElements,
      this.comments});

  @override
  List<Object> get props => [id];

  Post copyWith({
    String id,
    UserShortInfo author,
    TopicInfo topicInfo,
    DateTime createdAt,
    int likesCount,
    List<PostElement> postElements,
    List<Comment> comments,
  }) {
    return Post(
      id: id ?? id,
      author: author ?? this.author,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      likesCount: likesCount ?? this.likesCount,
      postElements: postElements ?? this.postElements,
      topicInfo: topicInfo ?? this.topicInfo
    );
  }
}

class Comment extends Equatable {
  final String id;
  final UserShortInfo author;
  final String text;
  final DateTime createdAt;

  Comment({this.id, this.author, this.text, this.createdAt});

  @override
  List<Object> get props => [id];
}
