
import 'package:champ/core/error/failure.dart';
import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/modules/auth/domain/entities/user.dart';
import 'package:champ/modules/auth/domain/usecases/auth_user.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' show GoogleAuthProvider;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final isSignedIn = Rx<bool>(false);
  final loadingState = Rx<LoadingState>();
  final currentUser = Rx<User>();
  
  final AuthUser _authUser;
  final GoogleSignIn _googleSignIn;

  AuthController({
    @required AuthUser authUser,
    @required GoogleSignIn googleSignIn
  }) : 
    _authUser = authUser,
    _googleSignIn = googleSignIn,
    super();

  @override
  void onInit() {
    once(isSignedIn, showDelayedSignInSnackBar);
    _authUser.isUserSignedIn().then((either) {
      either.fold(
        (failure) {
          currentUser.value = null;
          isSignedIn.value = false;
        },
        (user) {
          currentUser.value = user;
          isSignedIn.value = true;
        }
      );
    });
    super.onInit();
  }

  void signInUser() async {
    final googleUser = await _googleSignIn
          .signIn()
          .whenComplete(() => loadingState.value = LoadingState('Google sign in is finished.'));
    final googleAuth = await googleUser.authentication;
    final googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _authUser.signInWithGoogle(googleCredential);
    loadingState.value = LoadingState('Try to authenticate you with your data.');
    authResult.fold(
      (failure) => _showErrorSnackbar(failure),
      (user) {
        currentUser.value = user;
        loadingState.value = null;
      }
    );
  }

  void signOutUser() async {
    final authResult = await _authUser.signOut();
    loadingState.value = LoadingState('Try to authenticate you with your data.');
    authResult.fold(
      (failure) => _showErrorSnackbar(failure),
      (user) {
        currentUser.value = null;
        loadingState.value = null;
        isSignedIn.value = false;
      }
    );
  }

  void showDelayedSignInSnackBar(bool signedIn) {

  }

  void showSignInSnackBar() {
    final snackbar = GetBar(
      title: 'Авторизация',
      message: 'Используйте все возможности Champ',
      onTap: (snack) {
        signInUser();
      },
      mainButton: Container(
        margin: EdgeInsets.only(right: 20),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.orange30,
          borderRadius: BorderRadius.circular(5)
        ),
        child: Center(
          child: FlatButton(
            onPressed: () {
              signInUser();
            },
            padding: EdgeInsets.zero,
            child: Text(
              'G',
              style: TextStyles.weight600px25(color: AppColors.orange),
            ),
          ),
        ),
      ),
      duration: Duration(seconds: 5),
      borderRadius: 8,
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
    );
    
    Get.showSnackbar(snackbar);
  }

  void _showErrorSnackbar(Failure failure) {

  }

  Future<void> follow(String userId) async {
    if (currentUser.value != null) {
      final userShortInfo = await _authUser.follow(userId);
      currentUser.update((val) {
        val.followings.add(
          userShortInfo
        );
      });
    } else {
      showSignInSnackBar();
    }
  }

  Future<void> unfollow(String userId) async {
    if (currentUser.value != null) {
      _authUser.follow(userId);
      currentUser.update((val) {
        val.followings.removeWhere((e) => e.id == userId);
      });
    } else {
      showSignInSnackBar();
    }
  }
}

class LoadingState extends Equatable {
  final String message;

  LoadingState(this.message);

  @override
  List<Object> get props => [this.message];
}