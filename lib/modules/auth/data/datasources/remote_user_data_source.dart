
import 'dart:convert';

import 'package:champ/modules/auth/data/mappers/user_mapper.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/auth/domain/repositories/user_profile_repository.dart';

abstract class RemoteUserDataSource {
  Future<User> getUserByToken(String token);
  Future<User> getUserById(String id);
  Future<User> createNewUser(UserParams newUserParams);
  Future<UserShortInfo> follow(String userId);
  Future<void> unfollow(String userId);
}
