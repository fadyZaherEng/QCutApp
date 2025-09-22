import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:get/get.dart';

import 'notfication.dart';

class FirebaseMessagingNavigate {
  // forground
  static Future<void> forGroundHandler(RemoteMessage? message) async {
    print("foreground $message");
    if (message != null) {
      await LocalNotificationService.showSimpleNotification(
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        payload: message.data['productId'].toString(),
      );
    }
  }

  // background
  static void backGroundHandler(RemoteMessage? message) {
    if (message != null) {
      _navigate(message);
    }
  }

  // terminated
  static void terminatedHandler(RemoteMessage? message) {
    if (message != null) {
      _navigate(message);
    }
  }

  static void _navigate(RemoteMessage message) {
    Get.toNamed(AppRouter.notificationPath);

    if (int.parse(message.data['productId'].toString()) == -1) return;
    // sl<GlobalKey<NavigatorState>>().currentState!.context.pushName(
    //       AppRoutes.productDetails,
    //       arguments: int.parse(message.data['productId'].toString()),
    //     );
  }
}
