
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:champ/core/error/exception.dart';
import 'package:champ/core/util/network_info.dart';
import 'package:champ/core/util/storage/remote_storage.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/post_feed/data/datasources/remote_post_datasource.dart';
import 'package:champ/modules/post_feed/domain/entities/post.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/post_feed/domain/entities/post_page.dart';
import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/post_feed/domain/repositories/post_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class PostRepositoryImpl extends PostRepository {
  final RemotePostDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;
  final RemoteStorage _remoteStorage;

  PostRepositoryImpl({
    @required RemotePostDataSource remoteDataSource,
    @required NetworkInfo networkInfo,
    @required RemoteStorage remoteStorage,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo,
       _remoteStorage = remoteStorage,
       super();

  @override
  Future<Either<Failure, PostPage>> getPostPageByTopics(
      List<TopicInfo> topicList,
      String lastEvaluatedKey
  ) async {

    if (await _networkInfo.isConnected) {
      try {
        final topicIds = topicList.map((e) => e.id).toList();
        final postPage = await _remoteDataSource.getPostPageByTopics(topicIds, lastEvaluatedKey);
        return Right(postPage);
      } on Exception {
        print('PostRepository: other exception');
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
          )
        );
      }
    } else {
      print('PostRepository: connection failure');
      return Left(
        ConnectionFailure(
          userMessage: 'You are offline maybe. Check your connection.',
        )
      );
    }
  }

  @override
  Future<Either<Failure, Post>> createPost(Post post, UserShortInfo author) async {
      if (await _networkInfo.isConnected) {
      try {
        final resultPost = await _remoteDataSource.createPost(post, author);
        return Right(resultPost);
      } on Exception {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
          )
        );
      }
    } else {
      return Left(
        ConnectionFailure(
          userMessage: 'You are offline maybe. Check your connection.',
        )
      );
    }
  }
  
  @override
  Future<Either<Failure, String>> uploadFile(File file) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _remoteStorage.uploadFile(file);
        return Right(url);
      } on ApiException catch(e) {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
            devMessage: e.message,
            recoverySuggestion: e.recoverySuggestion,
          )
        );
      } on RemoteStorageException catch(e) {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
            devMessage: e.message
          )
        );
      }
    } else {
      return Left(
        ConnectionFailure(
          userMessage: 'You are offline maybe. Check your connection.',
        )
      );
    }
  }

  @override
  Future<Either<Failure, int>> createPostLike(String postId, String userId, int likesCount, String likeId) async {
      if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.createPostLike(postId, userId, likesCount, likeId);
        return Right(0);
      } on ApiException catch(e) {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
            devMessage: e.message,
            recoverySuggestion: e.recoverySuggestion,
          )
        );
      } on Exception {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
          )
        );
      }
    } else {
      return Left(
        ConnectionFailure(
          userMessage: 'You are offline maybe. Check your connection.',
        )
      );
    }
  }

  @override
  Future<Either<Failure, int>> deletePostLike(String postId, String userId, int likesCount, String likeId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deletePostLike(postId, userId, likesCount, likeId);
        return Right(0);
      } on FormatException catch(e) {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
            devMessage: e.message,
          )
        );
      } on Exception {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
          )
        );
      }
    } else {
      return Left(
        ConnectionFailure(
          userMessage: 'You are offline maybe. Check your connection.',
        )
      );
    }
  }

  @override
  Future<Either<Failure, PostPage>> getCreatedPostPageByUserId(String userId, String lastEvaluatedKey) async {
    if (await _networkInfo.isConnected) {
      try {
        final postPage = await _remoteDataSource.getCreatedPostPageByUserId(userId, lastEvaluatedKey);
        return Right(postPage);
      } on Exception {
        print('PostRepository: other exception');
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
          )
        );
      }
    } else {
      print('PostRepository: connection failure');
      return Left(
        ConnectionFailure(
          userMessage: 'You are offline maybe. Check your connection.',
        )
      );
    }
  } 

  @override
  Future<Either<Failure, List<Topic>>> getAllTopics() async {
    if (await _networkInfo.isConnected) {
      try {
        final allTopics = await _remoteDataSource.getAllTopics();
        return Right(allTopics);
      } on Exception {
        print('PostRepository: other exception');
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
          )
        );
      }
    } else {
      print('PostRepository: connection failure');
      return Left(
        ConnectionFailure(
          userMessage: 'You are offline maybe. Check your connection.',
        )
      );
    }
  } 

}