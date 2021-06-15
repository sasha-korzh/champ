
import 'dart:convert';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/data/mappers/post_mapper.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/post_page.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';

abstract class RemotePostDataSource {
  Future<PostPage> getPostPageByTopics(List<String> topicIds, String lastEvaluatedKey);
  Future<PostPage> getCreatedPostPageByUserId(String userId, String lastEvaluatedKey);
  Future<List<Topic>> getAllTopics();
  Future<Post> createPost(Post post, UserShortInfo author);  
  Future<void> createPostLike(String postId, String userId, int likesCount, String likeId);  
  Future<void> deletePostLike(String postId, String userId, int likesCount, String likeId);  
}
