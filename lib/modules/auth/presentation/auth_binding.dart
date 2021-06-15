

import 'package:champ/modules/auth/data/repositories/user_repository_impl.dart';
import 'package:champ/modules/auth/domain/repositories/user_profile_repository.dart';
import 'package:champ/modules/auth/domain/usecases/auth_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(
      networkInfo: Get.find(),
      remoteDataSource: Get.find()
    ));
    Get.put(FirebaseAuth.instance);
    Get.put(GoogleSignIn());
    Get.put(AuthUser(
      firebaseAuth: Get.find(),
      googleSignIn: Get.find(),
      localStorage: Get.find(),
      userRepository: Get.find(),
    ));
    Get.put(AuthController(authUser: Get.find(), googleSignIn: Get.find()));
  }

}