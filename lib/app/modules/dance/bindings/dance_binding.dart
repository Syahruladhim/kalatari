import 'package:get/get.dart';
import '../controllers/dance_controller.dart';

class DanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DanceController>(
      () => DanceController(),
    );
  }
}
