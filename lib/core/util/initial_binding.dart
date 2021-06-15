
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:champ/core/util/graphql_requests.dart';
import 'package:champ/core/util/network_info.dart';
import 'package:champ/core/util/storage/local_storage.dart';
import 'package:champ/core/util/storage/remote_storage.dart';
import 'package:champ/modules/auth/data/datasources/fake_user_data_source.dart';
import 'package:champ/modules/auth/data/datasources/remote_user_data_source.dart';
import 'package:champ/modules/auth/data/mappers/user_mapper.dart';
import 'package:champ/modules/post_feed/data/mappers/post_mapper.dart';
import 'package:champ/modules/screen_util_init/screen_util_controller.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get/get.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get_storage/get_storage.dart';

import 'package:champ/amplifyconfiguration.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() async {
    Get.putAsync(() async => _configureAmplify());
    Get.put(GraphQLUtil());
    Get.put(ScreenUtilController());
    Get.lazyPut<LocalStorage>(() => GetxLocalStorage(GetStorage()));
    Get.put(PostMapper());
    Get.put(UserMapper());
    Get.put(DataConnectionChecker());
    Get.lazyPut<NetworkInfo>(() => NetworkInfoImpl(Get.find()));
    Get.lazyPut<RemoteStorage>(() => FirebaseRemoteStorage());
    Get.lazyPut<RemoteUserDataSource>(() => FakeUserDataSource());
  }

  void _configureAmplify() async {
    Amplify.addPlugin(AmplifyAPI());
    try {
        await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
        print("Tried to reconfigure Amplify; this can occur when your app restarts on Android.");
    }
  }

}