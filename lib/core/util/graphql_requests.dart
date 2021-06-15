
import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:champ/modules/auth/domain/repositories/user_profile_repository.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/post_element.dart';

class GraphQLUtil {

  String _createNewUserRequest = '''mutation CreateNewUser(\$userToken: String!, \$userId: ID!, \$fullname: String!, \$rating: Float!, \$avatarImageUrl: String!, \$backgroundImageUrl: String!) {
        createUser(input: {id: \$userId, gender: other, fullname: \$fullname, rating: \$rating, avatarImageUrl: \$avatarImageUrl, backgroundImageUrl: \$backgroundImageUrl}) {
          id
          fullname
          gender
          avatarImageUrl
          backgroundImageUrl
          rating
          topics {
            items {
              topic {
                id
                name
                avatarImageUrl
              }
            }
          }
          followers {
            items {
              follower {
                id
                fullname
              }
            }
          }
          following {
            items {
              follower {
                id
                fullname
                avatarImageUrl
                rating
              }
            }
          }
        }
        createUserAccount(input: {userAccountUserId: \$userId, userToken: \$userToken}) {
          user {
            id
          }
        }
    }''';

  String _getUserByIdRequest = '''query GetUserById(\$id: String!) {
      getUser(id: \$id) {
        id
          fullname
          gender
          avatarImageUrl
          backgroundImageUrl
          rating
          topics {
            items {
              topic {
                id
                name
                avatarImageUrl
              }
            }
          }
          followers {
            items {
              follower {
                id
                fullname
              }
            }
          }
          following {
            items {
              follower {
                id
                fullname
                avatarImageUrl
                rating
              }
            }
          }
      }
    }''';

  String _getUserByTokenRequest = '''query GetUserByToken(\$userToken: String!) {
      getUserAccount(userToken: \$userToken) {
        user {
          id
          fullname
          gender
          avatarImageUrl
          backgroundImageUrl
          rating
          topics {
            items {
              topic {
                id
                name
                avatarImageUrl
              }
            }
          }
          followers {
            items {
              follower {
                id
                fullname
              }
            }
          }
          following {
            items {
              follower {
                id
                fullname
                avatarImageUrl
                rating
              }
            }
          }
        }
      }
    }''';

  String _getPostsByTopicsRequest = '''query GetPostsByTopics(\$topicIds: [String], \$lastEvaluatedKey: AWSJSON) {
      getPostsByTopics(filter: {topicIds: \$topicIds, lastEvaluatedKey: \$lastEvaluatedKey}) {
        count
        lastEvaluatedKey
        items {
          id
          createdAt
          topic {
            id
            name
            avatarImageUrl
          }
          postElements {
            items {
              data
              type
            }
          }
          author {
            id
            fullname
            avatarImageUrl
            rating
          }
          likesCount
          comments {
            items {
              id
              text
              createdAt
              owner {
                id
                fullname
                avatarImageUrl
                rating
              }
            }
          }
        }
      }
    }''';

  String _createPostPart = '''
      createPost(input: {id: \$postId, authorId: \$authorId, topicId: \$topicId}) {
        id
        createdAt
        topic {
          id
          name
          avatarImageUrl
        }
        postElements {
          items {
            data
            type
          }
        }
        author {
          id
          fullname
          avatarImageUrl
          rating
        }
        likesCount
        comments {
          items {
            id
            text
            createdAt
            owner {
              id
              fullname
              avatarImageUrl
              rating
            }
          }
        }
      }
    }''';  

  String _createPostLike = '''mutation CreatePostLike(\$likesCount: Int, \$ownerId: ID, \$postId: ID, \$likeId: ID) {
    createPostLike(input: {id: \$likeId, ownerId: \$ownerId, postId: \$postId}) {
      id
      postId
    }
    updatePost(input: {likesCount: \$likesCount, id: \$postId}) {
      id
      likesCount
    }
  }''';  

  String _deletePostLike = '''mutation DeletePostLike(\$likesCount: Int, \$ownerId: ID, \$postId: ID, \$likeId: ID) {
    deletePostLike(input: {likeId: \$likeId}) {
      id
      postId
    }
    updatePost(input: {likesCount: \$likesCount, id: \$postId}) {
      id
      likesCount
    }
  }''';  


  GraphQLOperation createNewUser(UserParams newUserParams) {
    return Amplify.API.mutate(
      request: GraphQLRequest<String>(document: _createNewUserRequest, variables: {
      'userToken': newUserParams.token,
      'userId': newUserParams.userId,
      'fullname': newUserParams.fullname,
      'avatarImageUrl': newUserParams.avatarImageUrl,
      'backgroundImageUrl': newUserParams.backgroundImageUrl,
    }));
  }  

  GraphQLOperation getUserById(String id) {
    return Amplify.API.query(
      request: GraphQLRequest<String>(document: _getUserByIdRequest, variables: {
      'id': id,
    }));
  }  

  GraphQLOperation getUserByToken(String userToken) {
    return Amplify.API.query(
      request: GraphQLRequest<String>(document: _getUserByTokenRequest, variables: {
      'userToken': userToken,
    }));
  }  

  GraphQLOperation getPostsByTopics(List<String> topicIds, String lastEvaluatedKey) {
    if (lastEvaluatedKey == null) {
      var finalRequest = _getPostsByTopicsRequest
          .replaceFirst(', \$lastEvaluatedKey: AWSJSON', '');
      finalRequest = finalRequest.replaceFirst(', lastEvaluatedKey: \$lastEvaluatedKey', '');
      print('GraphQLOperation: finalRequest: ${finalRequest}');
      return Amplify.API.query(
        request: GraphQLRequest<String>(document: finalRequest, variables: {
        'topicIds': topicIds,
      }));
    } else {
      return Amplify.API.query(
        request: GraphQLRequest<String>(document: _getPostsByTopicsRequest, variables: {
        'topicIds': topicIds,
        'lastEvaluatedKey': lastEvaluatedKey
      }));
    }
  }

  GraphQLOperation createPost(Post post) {
    var counter = 0;
    var finalRequest = 'query GetUserByToken(\$postId: String!, \$authorId: String!, \$topicId: String!) {';
    var createPostElementStrings = post.postElements.map((element) {
      return generateCreatePostElementStr(counter, post.id, element);
    }).toList();
    createPostElementStrings.forEach((element) {
      finalRequest += element;
    });
    finalRequest += _createPostPart;
    return Amplify.API.query(
      request: GraphQLRequest<String>(document: finalRequest, variables: {
      'postId': post.id,
      'authorId': post.author.id,
      'topicId': post.topicInfo.id,
    }));
  }    

  String generateCreatePostElementStr(int counter, String postId, PostElement e) {
    return '''\np$counter: createPostElement(input: {postId: "$postId", type: ${e.type.toString()}, data: "${e.data}", id: "${e.id}"}) {
      id
      type
      data
    }''';
  }

  GraphQLOperation createPostLike(String postId, String ownerId, int likesCount, String likeId) {
    return Amplify.API.query(
      request: GraphQLRequest<String>(document: _createPostLike, variables: {
      'likeId': likeId,
      'postId': postId,
      'ownerId': ownerId,
      'likesCount': likesCount,
    }));
  }  

  GraphQLOperation deletePostLike(String postId, String ownerId, int likesCount, String likeId) {
    return Amplify.API.query(
      request: GraphQLRequest<String>(document: _deletePostLike, variables: {
      'postId': postId,
      'ownerId': ownerId,
      'likesCount': likesCount,
      'likeId': likeId,
    }));
  }  
 
}