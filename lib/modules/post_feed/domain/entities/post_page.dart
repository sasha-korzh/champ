

import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PostPage extends Equatable {
  final String lastEvaluatedKey;
  final List<Post> items;
  final int count;

  PostPage({
    @required this.lastEvaluatedKey,
    @required this.items,
    @required this.count,
  });

  @override
  List<Object> get props => [lastEvaluatedKey, items, count];
}