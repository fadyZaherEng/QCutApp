import 'package:get/get.dart';
import 'package:q_cut/modules/main/logic/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
  }
}
