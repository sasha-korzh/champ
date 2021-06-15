
import 'package:champ/core/util/network_info.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/training/data/datasources/remote_training_datasource.dart';
import 'package:champ/modules/training/domain/entities/training_page.dart';
import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/training/domain/repositories/training_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class TrainingRepositoryImpl extends TrainingRepository {
  final RemoteTrainingDatasource _remoteDataSource;
  final NetworkInfo _networkInfo;

  TrainingRepositoryImpl({
    @required RemoteTrainingDatasource remoteDataSource,
    @required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _networkInfo = networkInfo,
       super();

  @override
  Future<Either<Failure, TrainingPage>> getCreatedTrainingByUserId(String userId, String lastEvaluatedKey) async {
    if (await _networkInfo.isConnected) {
      try {
        final trainingPage = await _remoteDataSource.getCreatedTrainingByUserId(userId, lastEvaluatedKey);
        return Right(trainingPage);
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
  Future<Either<Failure, TrainingPage>> getSavedTrainingByUserId(String userId, String lastEvaluatedKey) async {
    if (await _networkInfo.isConnected) {
      try {
        final trainingPage = await _remoteDataSource.getSavedTrainingByUserId(userId, lastEvaluatedKey);
        return Right(trainingPage);
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
  Future<Either<Failure, TrainingPage>> getTrainingByTopics(List<TopicInfo> topicList, String lastEvaluatedKey) async {
    if (await _networkInfo.isConnected) {
      try {
        final topicIds = topicList.map((e) => e.id).toList();
        final trainingPage = await _remoteDataSource.getTrainingByTopicIds(topicIds, lastEvaluatedKey);
        return Right(trainingPage);
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
  Future<Either<Failure, int>> createTrainingLike(String trainingId, String userId, int likesCount, String likeId)  async {
      if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.createTrainingLike(trainingId, userId, likesCount, likeId);
        return Right(0);
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
  Future<Either<Failure, int>> deleteTrainingLike(String trainingId, String userId, int likesCount, String likeId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteTrainingLike(trainingId, userId, likesCount, likeId);
        return Right(0);
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

}