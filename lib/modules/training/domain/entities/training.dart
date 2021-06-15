import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:equatable/equatable.dart';

class Training extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final UserShortInfo author;
  final TopicInfo topic;
  final int likesCount;
  final List<Comment> comments;
  final DateTime createdAt;
  final int minutes;

  Training(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.videoUrl,
      this.author,
      this.topic,
      this.likesCount,
      this.comments,
      this.createdAt,
      this.minutes});

  @override
  List<Object> get props => [id];

  Training copyWith({
    String id,
    String title,
    String description,
    String imageUrl,
    String videoUrl,
    UserShortInfo author,
    TopicInfo topic,
    int likesCount,
    List<Comment> comments,
    DateTime createdAt,
    int minutes,
  }) {
    return Training(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      author: author ?? this.author,
      topic: topic ?? this.topic,
      likesCount: likesCount ?? this.likesCount,
      comments: comments ?? this.comments,
      createdAt: createdAt ?? this.createdAt,
      minutes: minutes ?? this.minutes,
    );
  }
}
