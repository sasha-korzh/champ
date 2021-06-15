
import 'dart:convert';

import 'package:champ/core/util/graphql_requests.dart';
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

class PostGraphQLDataSource extends RemotePostDataSource {
  final PostMapper postMapper;
  final GraphQLUtil graphQLutil;

  PostGraphQLDataSource({this.postMapper, this.graphQLutil});

  @override
  Future<PostPage> getPostPageByTopics(List<String> topicIds, String lastEvaluatedKey) async {
    final response = await graphQLutil.getPostsByTopics(topicIds, lastEvaluatedKey).response;
    print('PostDataSource: response data: ${response.data}');
    final Map<String, dynamic> responseJson = json.decode(response.data);
    final Map<String, dynamic> getPostsByTopicsJson = responseJson['getPostsByTopics'];

    return postMapper.postPageFromJson(getPostsByTopicsJson);
  }

  @override
  Future<Post> createPost(Post post, UserShortInfo author) async {
    final response = await graphQLutil.createPost(post).response;
    final Map<String, dynamic> responseJson = json.decode(response.data);
    final Map<String, dynamic> createPostJson = responseJson['createPost'];

    return postMapper.postFromJson(createPostJson);
  }

  @override
  Future<void> createPostLike(String postId, String userId, int likesCount, String likeId) async {
    await graphQLutil.createPostLike(postId, userId, likesCount, likeId).response;
  }

  @override
  Future<void> deletePostLike(String postId, String userId, int likesCount, String likeId) async {
    await graphQLutil.deletePostLike(postId, userId, likesCount, likeId).response;
  }

  @override
  Future<PostPage> getCreatedPostPageByUserId(String userId, String lastEvaluatedKey) {
    
  }

  @override
  Future<List<Topic>> getAllTopics() {
    // TODO: implement getAllTopics
    throw UnimplementedError();
  }
}