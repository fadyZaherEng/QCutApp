import 'package:get/get.dart';

class NavigationHelper {
  /// Navigate to a new screen
  static void navigateTo(String routeName, {dynamic arguments}) {
    Get.toNamed(routeName, arguments: arguments);
  }

  /// Navigate to a new screen and remove the previous screen from the stack
  static void navigateToAndReplace(String routeName, {dynamic arguments}) {
    Get.offNamed(routeName, arguments: arguments);
  }

  /// Navigate to a new screen and remove all previous screens from the stack
  static void navigateToAndRemoveUntil(String routeName, {dynamic arguments}) {
    Get.offAllNamed(routeName, arguments: arguments);
  }

  /// Go back to the previous screen
  static void goBack() {
    Get.back();
  }

  /// Get arguments passed to the current route
  static dynamic getArguments() {
    return Get.arguments;
  }
}
