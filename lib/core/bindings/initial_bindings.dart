import 'package:get/get.dart';
import 'package:q_cut/core/localization/change_local.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LocaleController(), permanent: true);
    // Add other controllers you need to initialize here
  }
}
