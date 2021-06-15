import 'package:champ/core/error/failure.dart';
import 'package:champ/core/util/storage/local_storage.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/domain/entities/user_short_info.dart';
import 'package:champ/modules/auth/domain/repositories/user_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthUser {
  final UserRepository userRepository;
  final LocalStorage localStorage;
  final GoogleSignIn googleSignIn;
  final fbAuth.FirebaseAuth firebaseAuth;

  AuthUser({
    @required this.userRepository,
    @required this.localStorage,
    @required this.googleSignIn,
    @required this.firebaseAuth,
  });

  Future<UserShortInfo> follow(String userId) async {
    userRepository.follow(userId);
  }

  Future<void> unfollow(String userId) async {
    userRepository.unfollow(userId);
  }

  Future<Either<Failure, User>> isUserSignedIn() async {
    final token = localStorage.getToken();
    if (token != null) {
      return userRepository.getUserByToken(token);
    } else {
      return Left(
        AuthFailure(userMessage: 'You are not authorized.')
      );
    }
  }

  Future<Either<Failure, User>> signOut() async {
    await firebaseAuth.signOut();
    await localStorage.deleteToken();
    return Right(null);
  }

  Future<Either<Failure, User>> signInWithGoogle(fbAuth.AuthCredential credential) async {
    final userCredential = await firebaseAuth.signInWithCredential(credential);
    if (userCredential != null && userCredential.user != null) {
      final token = await userCredential.user.getIdToken(true);
      final authRepoResult = await userRepository.getUserByToken(token);
      return authRepoResult.fold(
        (failure) => Left(failure),
        (user) => _onRepoSuccessResult(userCredential, user, token),
      );
    } else {
      return Left(
        AuthFailure(userMessage: 'We have problems with your google credentials.')
      );
    }
  }

  Future<Either<Failure, User>> _onRepoSuccessResult(fbAuth.UserCredential userCredential, User user, String token) async {
    if (user == null) {
      final newUserParams = UserParams.newUser(
        token: token,
        userId: userCredential.user.uid,
        fullname: userCredential.user.displayName,
        avatarImageUrl: userCredential.user.photoURL,
        
      );
      final createUserResult = await userRepository.createNewUser(newUserParams);
      return createUserResult.fold(
        (failure) => Left(failure), 
        (user) {
          localStorage.saveToken(token);
          return Right(user);
        }
      );
    } else {
      localStorage.saveToken(token);
      return Right(user);
    }
  }
}