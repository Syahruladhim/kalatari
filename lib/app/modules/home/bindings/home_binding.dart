import 'package:kalatari_app/app/modules/detection/controllers/detection_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../dance/controllers/dance_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../data/services/api_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../event/controllers/event_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Register ApiService first since other controllers depend on it
    Get.put<ApiService>(
      ApiService(),
      permanent: true,
    );

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<DanceController>(
      () => DanceController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
    Get.lazyPut<EventController>(
      () => EventController(),
    );
    Get.lazyPut<DetectionController>(
      () => DetectionController(),
    );
  }
}
