
import 'package:amplify_api/amplify_api.dart';
import 'package:champ/core/util/network_info.dart';
import 'package:champ/modules/auth/data/datasources/remote_user_data_source.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/core/error/failure.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/auth/domain/repositories/user_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class UserRepositoryImpl extends UserRepository {
  final RemoteUserDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  UserRepositoryImpl({
    @required RemoteUserDataSource remoteDataSource,
    @required NetworkInfo networkInfo,
  }) : this._remoteDataSource = remoteDataSource,
       this._networkInfo = networkInfo,
       super();

  @override
  Future<Either<Failure, User>> createNewUser(UserParams newUserParams) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.createNewUser(newUserParams);
        return Right(user);
      } on ApiException catch(e) {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
            devMessage: e.message,
            recoverySuggestion: e.recoverySuggestion,
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
  Future<Either<Failure, User>> getUserById(String id) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getUserById(id);
        return Right(user);
      } on ApiException catch (e) {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
            devMessage: e.message,
            recoverySuggestion: e.recoverySuggestion,
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
  Future<Either<Failure, User>> getUserByToken(String token) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getUserByToken(token);
        return Right(user);
      } on ApiException catch (e) {
        return Left(
          ServerFailure(
            userMessage: 'We have some problems with our server.(',
            devMessage: e.message,
            recoverySuggestion: e.recoverySuggestion,
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
  Future<UserShortInfo> follow(String userId) async {
      return _remoteDataSource.follow(userId);
  }

  @override
  Future<void> unfollow(String userId) async {
    if (await _networkInfo.isConnected) {
      await _remoteDataSource.unfollow(userId);      
    } else {
      return Left(
        ConnectionFailure(
          userMessage: 'You are offline maybe. Check your connection.',
        )
      );
    }
  }

}