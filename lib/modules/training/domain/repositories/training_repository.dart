
import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/post_feed/domain/entities/topic.dart';
import 'package:champ/modules/training/domain/entities/training_page.dart';
import 'package:dartz/dartz.dart';

abstract class TrainingRepository {
  Future<Either<Failure, TrainingPage>> getCreatedTrainingByUserId(String userId, String lastEvaluatedKey);
  Future<Either<Failure, TrainingPage>> getSavedTrainingByUserId(String userId, String lastEvaluatedKey);
  Future<Either<Failure, TrainingPage>> getTrainingByTopics(List<TopicInfo> topicList, String lastEvaluatedKey);
  Future<Either<Failure, int>> createTrainingLike(String trainingId, String userId, int likesCount, String likeId);
  Future<Either<Failure, int>> deleteTrainingLike(String trainingId, String userId, int likesCount, String likeId);
}