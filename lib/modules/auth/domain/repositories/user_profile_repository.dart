
import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> createNewUser(UserParams newUserParams);

  Future<Either<Failure, User>> getUserById(String id);

  Future<Either<Failure, User>> getUserByToken(String token);

  Future<UserShortInfo> follow(String userId);

  Future<void> unfollow(String userId);
}

class UserParams {
  final String token;
  final String userId;
  final String fullname;
  final String avatarImageUrl;
  final String backgroundImageUrl;

  UserParams({
    this.token,
    this.userId, 
    this.fullname, 
    this.avatarImageUrl,
    this.backgroundImageUrl
  });

  UserParams.newUser({
    this.token,
    this.userId, 
    this.fullname, 
    this.avatarImageUrl}) 
  : 
    backgroundImageUrl = '';

}