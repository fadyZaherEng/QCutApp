import 'package:firebase_messaging/firebase_messaging.dart';

import 'notfication.dart';

class FirebaseMessagingNavigate {
  static Future<void> forGroundHandler(RemoteMessage? message) async {
    if (message != null) {
      _navigate(message);
      print("foreground $message");
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
    print("message.data ${message.data}");

    // تمرير البيانات العامة (للاستخدام في أي مكان)
    onNotificationClick?.add("notification");

    final data = message.data;

    // تحقق من وجود productId وصحته
    final productIdRaw = data['productId'];
    if (productIdRaw == null) {
      print("⚠️ No productId in message");
      return;
    }

    final productIdString = productIdRaw.toString();
    final productId = int.tryParse(productIdString);

    if (productId == null) {
      print("⚠️ Invalid productId: $productIdString");
      return;
    }

    if (productId == -1) {
      print("🚫 Ignoring notification (productId = -1)");
      return;
    }

    // ✅ الآن الـ productId صالح
    print("✅ Navigate to product: $productId");

    // Example: Navigate (replace with your actual navigation)
    // sl<GlobalKey<NavigatorState>>().currentState!.context.pushName(
    //   AppRoutes.productDetails,
    //   arguments: productId,
    // );
  }
}
