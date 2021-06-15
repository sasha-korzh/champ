
import 'dart:convert';

import 'package:champ/core/error/failure.dart';
import 'package:champ/core/util/storage/local_storage.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/training/domain/entities/training_page.dart';
import 'package:champ/modules/training/domain/repositories/training_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

class TrainingUsecase {
  final TrainingRepository _trainingRepository;
  final LocalStorage _localStorage;

  TrainingUsecase({
    @required TrainingRepository trainingRepository,
    @required LocalStorage localStorage,
  }) 
  : _trainingRepository = trainingRepository,
    _localStorage = localStorage,
    super();

  Future<Either<Failure, TrainingPage>> getCreatedTrainingByUserId(String userId, String lastEvaluatedKey) async {
    return _trainingRepository.getCreatedTrainingByUserId(userId, lastEvaluatedKey);
  }

  Future<Either<Failure, TrainingPage>> getSavedTrainingByUserId(String userId, String lastEvaluatedKey) async {
    return _trainingRepository.getSavedTrainingByUserId(userId, lastEvaluatedKey);
  }

  Future<Either<Failure, TrainingPage>> getTrainingByUserTopics(List<TopicInfo> topics, String lastEvaluatedKey) async {
    return _trainingRepository.getTrainingByTopics(topics, lastEvaluatedKey);
  }
  
  Future<Either<Failure, int>> createTrainingLike(String trainingId, String userId, int likesCount, Map<String, String> likedTrainingIds) async {
    _localStorage.saveLikedTrainings(userId, json.encode(likedTrainingIds));
    final likeId = likedTrainingIds[trainingId];
    return _trainingRepository.createTrainingLike(trainingId, userId, likesCount, likeId);
  }

  Future<Either<Failure, int>> deleteTrainingLike(String trainingId, String userId, int likesCount, String likeId) async {
    return _trainingRepository.deleteTrainingLike(trainingId, userId, likesCount, likeId);
  }

  Future<Map<String, String>> getLikedTrainingsByUserId(String userId) async {
    final str =_localStorage.fetchLikedTrainings(userId);
    if (str != null && str.isNotEmpty) {
      return json.decode(str);
    } else {
      return {};
    }
  }
}