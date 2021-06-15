
import 'package:equatable/equatable.dart';

class UserShortInfo extends Equatable {
  final String id;
  final String fullname;
  final String avatarImageUrl;

  UserShortInfo({
      this.id,
      this.fullname,
      this.avatarImageUrl,
      });

  @override
  List<Object> get props => [id];
}