
import 'dart:convert';

import 'package:champ/core/error/failure.dart';
import 'package:champ/core/util/storage/local_storage.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';
import 'package:champ/modules/post_feed/domain/entities/post_page.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/post_feed/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PostUsecase {
  final PostRepository _postRepository;
  final LocalStorage _localStorage;

  PostUsecase({
    @required PostRepository postRepository,
    @required LocalStorage localStorage,
  }) 
  : _postRepository = postRepository,
    _localStorage = localStorage,
    super();

  Future<Either<Failure, PostPage>> getPostsByUserTopics(List<TopicInfo> topics, String lastEvaluatedKey) async {
    return _postRepository.getPostPageByTopics(topics, lastEvaluatedKey);
  }

  Future<Either<Failure, List<Topic>>> getAllTopics() async {
    return _postRepository.getAllTopics();
  }

  Future<Either<Failure, PostPage>> getCreatedPostsByUserId(String userId, String lastEvaluatedKey) async {
    return _postRepository.getCreatedPostPageByUserId(userId, lastEvaluatedKey);
  }

  Future<Either<Failure, Post>> createPost(Post post, List<PostElementFile> postElementFiles, UserShortInfo author) async {
    // postElementFiles.forEach((pef) async {
    //   final uploadResult = await _postRepository.uploadFile(pef.file);
    //   uploadResult.fold(
    //     (failure) => Left(failure), 
    //     (url) {
    //       post.postElements
    //       .firstWhere((pe) => pe.id == pef.postElementId)
    //       .data = url;
    //     }
    //   );
    // });

    return _postRepository.createPost(post, author);
  }

  Future<Either<Failure, int>> createPostLike(String postId, String userId, int likesCount, RxList<String> likedPostsIds) async {
    _localStorage.saveLikedPosts(userId, likedPostsIds.toJson().toString());
    return _postRepository.createPostLike(postId, userId, likesCount, DateTime.now().microsecond.toString());
  }

  Future<Either<Failure, int>> deletePostLike(String postId, String userId, int likesCount, RxList<String> likedPostsIds) async {
    _localStorage.saveLikedPosts(userId, likedPostsIds.toJson().toString());
    return _postRepository.deletePostLike(postId, userId, likesCount, DateTime.now().microsecond.toString());
  }

  List<String> getLikedPostsByUserId(String userId) {
    final str = _localStorage.fetchLikedPosts(userId);
    if (str != null && str.isNotEmpty) {
      final jsonDecoded = json.decode(str);
      print('json str: $str');
      print('json decode: $jsonDecoded');
      return List<String>.from(json.decode(str));
    } else {
      return [];
    }
  }


}