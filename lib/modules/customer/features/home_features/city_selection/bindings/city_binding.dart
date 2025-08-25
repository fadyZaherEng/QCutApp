import 'package:get/get.dart';
import 'package:q_cut/modules/customer/features/home_features/city_selection/logic/city_controller.dart';

class CityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CityController>(
      () => CityController(),
      fenix: true,
    );
  }
}
