

import 'package:champ/modules/auth/data/datasources/remote_user_data_source.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/auth/domain/repositories/user_profile_repository.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';

class FakeUserDataSource extends RemoteUserDataSource {
  var currentUser = User(
    backgroundImageUrl: '',
    followers: [],
    followings: [],
    gender: Gender.man,
    topics: [],
    savedTraining: [],
    id: 'user-id1',
    fullname: 'Иван Фейковый',
    avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
  );

  @override
  Future<User> createNewUser(UserParams newUserParams) async {
    currentUser = currentUser.copyWith(
      id: newUserParams.userId,
      fullname: newUserParams.fullname,
      avatarImageUrl: newUserParams.avatarImageUrl,
    );
    return currentUser;
  }

  @override
  Future<User> getUserById(String id) async {
    return allUsers.firstWhere((e) => e.id == id);
  }

  @override
  Future<User> getUserByToken(String token) async {
    return null;
  }

  @override
  Future<UserShortInfo> follow(String userId) async {
    final userShortInfo = UserShortInfo(
      id: userId,
      fullname: allUsers.firstWhere((e) => e.id == userId).fullname,
      avatarImageUrl: allUsers.firstWhere((e) => e.id == userId).avatarImageUrl,
    );
    currentUser.followings.add(
      userShortInfo
    );
    return userShortInfo;
  }

  @override
  Future<void> unfollow(String userId) async {
    currentUser.followings.removeWhere((e) => e.id == userId);
  }









    var allUsers = [
    User(
      backgroundImageUrl: '',
      followers: [],
      followings: [],
      gender: Gender.man,
      topics: [],
      savedTraining: [],
      id: 'user-id1',
      fullname: 'Иван Фейковый',
      avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
    ),
    User(
      backgroundImageUrl: '',
      followers: [],
      followings: [],
      gender: Gender.man,
      topics: [],
      savedTraining: [],
      id: 'user-id1',
      fullname: 'Иван Фейковый',
      avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
    ),
    User(
      backgroundImageUrl: '',
      followers: [],
      followings: [],
      gender: Gender.man,
      topics: [],
      savedTraining: [],
      id: 'user-id1',
      fullname: 'Иван Фейковый',
      avatarImageUrl: 'https://images.unsplash.com/photo-1618487113651-a8604c0fd3c7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=334&q=80',
    ),
  ];
}