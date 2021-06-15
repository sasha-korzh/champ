
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/training/domain/entities/training.dart';
import 'package:champ/modules/training/domain/entities/training_page.dart';
import 'package:dartz/dartz.dart';

abstract class RemoteTrainingDatasource {
  Future<TrainingPage> getCreatedTrainingByUserId(String userId, String lastEvaluatedKey);
  Future<TrainingPage> getSavedTrainingByUserId(String userId, String lastEvaluatedKey);
  Future<TrainingPage> getTrainingByTopicIds(List<String> topicIds, String lastEvaluatedKey);
  createTrainingLike(String trainingId, String userId, int likesCount, String likeId);
  deleteTrainingLike(String trainingId, String userId, int likesCount, String likeId);
}

class FakeTrainingDatasource extends RemoteTrainingDatasource {
  final List<Training> savedTrainings = [

  ];

  final List<Training> trainings = [
    Training(
      id: 'training_id1',
      title: 'Тренування: Руки та Плечі',
      author: UserShortInfo(
        id: 'user-id1',
        fullname: 'Иван Фейковый',
        avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
      ),
      createdAt: DateTime.now(),
      description: 'Боді скалпт (або ж скульпт) – чудова альтернатива тренажерному залу. Кажучи іншими словами, це чудовий фітнес-напрямок, який допомагає вам створити красиве і підкачане тіло у короткі терміни. Такі тренування проходять в аеробному режимі і в основному мають на меті «прокачати» крупні групи м’язів. Якщо ви надаєте перевагу динамічним заняттям, то боді скульпт – справжня знахідка!',
      comments: [],
      imageUrl: 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1049&q=80',
      likesCount: 17,
      minutes: 24,
      videoUrl: ''
    ),
    Training(
      id: 'training_id1',
      title: 'Тренування: Руки та Плечі',
      author: UserShortInfo(
        id: 'user-id1',
        fullname: 'Иван Фейковый',
        avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
      ),
      createdAt: DateTime.now(),
      description: 'Боді скалпт (або ж скульпт) – чудова альтернатива тренажерному залу. Кажучи іншими словами, це чудовий фітнес-напрямок, який допомагає вам створити красиве і підкачане тіло у короткі терміни. Такі тренування проходять в аеробному режимі і в основному мають на меті «прокачати» крупні групи м’язів. Якщо ви надаєте перевагу динамічним заняттям, то боді скульпт – справжня знахідка!',
      comments: [],
      imageUrl: 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1049&q=80',
      likesCount: 17,
      minutes: 24,
      videoUrl: ''
    ),
    Training(
      id: 'training_id1',
      title: 'Тренування: Руки та Плечі',
      author: UserShortInfo(
        id: 'user-id1',
        fullname: 'Иван Фейковый',
        avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
      ),
      createdAt: DateTime.now(),
      description: 'Боді скалпт (або ж скульпт) – чудова альтернатива тренажерному залу. Кажучи іншими словами, це чудовий фітнес-напрямок, який допомагає вам створити красиве і підкачане тіло у короткі терміни. Такі тренування проходять в аеробному режимі і в основному мають на меті «прокачати» крупні групи м’язів. Якщо ви надаєте перевагу динамічним заняттям, то боді скульпт – справжня знахідка!',
      comments: [],
      imageUrl: 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1049&q=80',
      likesCount: 17,
      minutes: 24,
      videoUrl: ''
    ),
    Training(
      id: 'training_id1',
      title: 'Тренування: Руки та Плечі',
      author: UserShortInfo(
        id: 'user-id1',
        fullname: 'Иван Фейковый',
        avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
      ),
      createdAt: DateTime.now(),
      description: 'Боді скалпт (або ж скульпт) – чудова альтернатива тренажерному залу. Кажучи іншими словами, це чудовий фітнес-напрямок, який допомагає вам створити красиве і підкачане тіло у короткі терміни. Такі тренування проходять в аеробному режимі і в основному мають на меті «прокачати» крупні групи м’язів. Якщо ви надаєте перевагу динамічним заняттям, то боді скульпт – справжня знахідка!',
      comments: [],
      imageUrl: 'https://images.unsplash.com/photo-1599058917212-d750089bc07e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1049&q=80',
      likesCount: 17,
      minutes: 24,
      videoUrl: ''
    ),
  ];

  @override
  Future<TrainingPage> getCreatedTrainingByUserId(String userId, String lastEvaluatedKey) async {
    final list = trainings.where((e) => e.author.id == userId).toList();
    if (lastEvaluatedKey == 'last') {
      list.shuffle();
      return TrainingPage(
        lastEvaluatedKey: null,
        items: list,
        count: list.length,
      );
    } 
    return TrainingPage(
      lastEvaluatedKey: 'last',
      items: list,
      count: list.length,
    );
  }
  
  @override
  Future<TrainingPage> getSavedTrainingByUserId(String userId, String lastEvaluatedKey) async {
    if (lastEvaluatedKey == 'last') {
      return TrainingPage(
        lastEvaluatedKey: null,
        items: [],
        count: 0,
      );
    } 
    return TrainingPage(
      lastEvaluatedKey: 'last',
      items: savedTrainings,
      count: savedTrainings.length,
    );
  }
  
  @override
  Future<TrainingPage> getTrainingByTopicIds(List<String> topicIds, String lastEvaluatedKey) async {
    final list = trainings;
    if (lastEvaluatedKey == 'last') {
      list.shuffle();
      return TrainingPage(
        lastEvaluatedKey: null,
        items: list,
        count: list.length,
      );
    } 
    return TrainingPage(
      lastEvaluatedKey: 'last',
      items: list,
      count: list.length,
    );
  }

  Future<void> saveTraining(String userId, String trainingId) async {
    savedTrainings.add(trainings.firstWhere((e) => e.id == trainingId));
  }

  Future<void> unsaveTraining(String userId, String trainingId) async {
    savedTrainings.removeWhere((e) => e.id == trainingId);
  }

  @override
  createTrainingLike(String trainingId, String userId, int likesCount, String likeId) {
    final currentTraining = trainings.firstWhere((e) => e.id == trainingId);
    final index = trainings.indexOf(currentTraining);
    trainings.insert(index, currentTraining.copyWith(likesCount: currentTraining.likesCount + 1));
    trainings.removeAt(index + 1);
  }
  
  @override
  deleteTrainingLike(String trainingId, String userId, int likesCount, String likeId) {
    final currentTraining = trainings.firstWhere((e) => e.id == trainingId);
    final index = trainings.indexOf(currentTraining);
    trainings.insert(index, currentTraining.copyWith(likesCount: currentTraining.likesCount - 1));
    trainings.removeAt(index + 1);
  }

}