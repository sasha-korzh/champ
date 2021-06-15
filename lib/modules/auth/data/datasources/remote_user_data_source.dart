
import 'dart:convert';

import 'package:champ/core/util/graphql_requests.dart';
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

class AmplifyGraphQLDataSource extends RemoteUserDataSource {
  final UserMapper userMapper;
  final GraphQLUtil graphQLutil;

  AmplifyGraphQLDataSource({this.userMapper, this.graphQLutil});

  @override
  Future<User> createNewUser(UserParams newUserParams) async {
    final response = await graphQLutil.createNewUser(newUserParams).response;
    final Map<String, dynamic> responseJson = json.decode(response.data);
    final Map<String, dynamic> createUserJson = responseJson['createUser'];

    if (createUserJson == null) {
      return null;
    }

    return userMapper.userFromJson(createUserJson);
  }
  
  @override
  Future<User> getUserById(String id) async {
    final response = await graphQLutil.getUserById(id).response;
    final Map<String, dynamic> responseJson = json.decode(response.data);
    final Map<String, dynamic> getUserJson = responseJson['getUser'];

    if (getUserJson == null) {
      return null;
    }

    return userMapper.userFromJson(getUserJson);
  }
  
  @override
  Future<User> getUserByToken(String userToken) async {
    final response = await graphQLutil.getUserByToken(userToken).response;
    print(response.data);
    if (response.data == null) {
      return null;
    } 
    final Map<String, dynamic> responseJson = json.decode(response.data);
    final Map<String, dynamic> getUserAccountJson = responseJson['getUserAccount'];

    if (getUserAccountJson == null) {
      return null;
    }

    return userMapper.userFromJson(getUserAccountJson['user']);
  }

  @override
  Future<UserShortInfo> follow(String userId) {
      // TODO: implement follow
      throw UnimplementedError();
    }
  
    @override
    Future<void> unfollow(String userId) {
    // TODO: implement unfollow
    throw UnimplementedError();
  }

}