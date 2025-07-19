import 'package:get/get.dart';
import '../controller/select_appointment_time_controller.dart';

class SelectAppointmentTimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectAppointmentTimeController());
  }
}
