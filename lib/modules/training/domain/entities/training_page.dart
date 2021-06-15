

import 'package:champ/modules/training/domain/entities/training.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class TrainingPage extends Equatable {
  final String lastEvaluatedKey;
  final List<Training> items;
  final int count;

  TrainingPage({
    @required this.lastEvaluatedKey,
    @required this.items,
    @required this.count,
  });

  @override
  List<Object> get props => [lastEvaluatedKey, items, count];
}