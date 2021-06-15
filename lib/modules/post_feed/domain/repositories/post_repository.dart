
import 'dart:io';

import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/post_page.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:dartz/dartz.dart';

abstract class PostRepository {
  Future<Either<Failure, PostPage>> getPostPageByTopics(List<TopicInfo> topicList, String lastEvaluatedKey);
  Future<Either<Failure, String>> uploadFile(File file);
  Future<Either<Failure, Post>> createPost(Post post, UserShortInfo author);
  Future<Either<Failure, int>> createPostLike(String postId, String userId, int likesCount, String likeId);
  Future<Either<Failure, int>> deletePostLike(String postId, String userId, int likesCount, String likeId);
  Future<Either<Failure, PostPage>> getCreatedPostPageByUserId(String userId, String lastEvaluatedKey);
  Future<Either<Failure, List<Topic>>> getAllTopics();
}