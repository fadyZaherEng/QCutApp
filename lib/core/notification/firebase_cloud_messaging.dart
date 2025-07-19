import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'firebase_messaging_navigate.dart';

class FirebaseCloudMessaging {
  factory FirebaseCloudMessaging() => _instance;

  FirebaseCloudMessaging._();

  static final FirebaseCloudMessaging _instance = FirebaseCloudMessaging._();

  static const String subscribeKey = 'Enmaa';

  final _firebaseMessaging = FirebaseMessaging.instance;

  ValueNotifier<bool> isNotificationSubscribe = ValueNotifier(true);

  bool isPermissionNotification = false;

  Future<void> init() async {
    //permission
    await _permissionsNotification();

    // forground
    FirebaseMessaging.onMessage
        .listen(FirebaseMessagingNavigate.forGroundHandler);

    // terminated
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then(FirebaseMessagingNavigate.terminatedHandler);

    // background
    FirebaseMessaging.onMessageOpenedApp
        .listen(FirebaseMessagingNavigate.backGroundHandler);
  }

  /// controller for the notification if user subscribe or unsubscribed
  /// or accpeted the permission or not

  Future<void> controllerForUserSubscribe(BuildContext context) async {
    if (isPermissionNotification == false) {
      await _permissionsNotification();
    } else {
      if (isNotificationSubscribe.value == false) {
        await _subscribeNotification();
        if (!context.mounted) return;
      } else {
        await _unSubscribeNotification();
        if (!context.mounted) return;
      }
    }
  }

  /// permissions to notifications
  Future<void> _permissionsNotification() async {
    final settings = await _firebaseMessaging.requestPermission(badge: false);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      /// subscribe to notifications topic
      isPermissionNotification = true;
      await _subscribeNotification();
      debugPrint('🔔🔔 User accepted the notification permission');
    } else {
      isPermissionNotification = false;
      isNotificationSubscribe.value = false;
      debugPrint('🔕🔕 User not accepted the notification permission');
    }
  }

  /// subscribe notification

  Future<void> _subscribeNotification() async {
    isNotificationSubscribe.value = true;
    await FirebaseMessaging.instance.subscribeToTopic(subscribeKey);
    debugPrint('====🔔 Notification Subscribed 🔔=====');
  }

  /// unsubscribe notification

  Future<void> _unSubscribeNotification() async {
    isNotificationSubscribe.value = false;
    await FirebaseMessaging.instance.unsubscribeFromTopic(subscribeKey);
    debugPrint('====🔕 Notification Unsubscribed 🔕=====');
  }

// send notifcation with api
  Future<void> sendTopicNotification({
    required String title,
    required String body,
    required String token,
  }) async {
    try {
      final response = await Dio().post<dynamic>(
        "https://fcm.googleapis.com/v1/projects/qcute-c4d8f/messages:send",
        options: Options(
          validateStatus: (_) => true,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${await getAccessToken()}',
          },
        ),
        data: {
          "message": {
            "token": token,
            "notification": {"title": title, "body": body},
          }
        },
      );

      debugPrint('Notification Created => ${response.data}');
    } catch (e) {
      debugPrint('Notification Error => $e');
    }
  }

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final Map<String, dynamic> serviceAccountJson = {
      "type": "service_account",
      "project_id": "qcute-c4d8f",
      "private_key_id": "b9a71672bc185036ea63f8f992ede3746f74aba3",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC4OuJja0o0xSbb\n3XC5yCd2kay3CpzT/B3DRkkGT7x3kGaEwicAuW949OBpWRIOeHpHR9y+8ydElnSF\nB7qcovZj+3V0BMIbi73ht42zGtJ+8TTd2wn+G6dU19b1p9WcLNwZQJHfkeB9h3NY\n5FGQfxTErPg3nn4+DdPrajajVNNt/SOy7IDw7uG8yCeRHwzTuAHUfS6q1HFSaK0F\nFQ5Gw0RdJIzmyqBpv6tq4Qh8SM7REXnZn2/a1CX5G5gpEnHnDtPmP75aD9b6G7Ss\nsC/lQ0L//Tz8fp5WiQostVkrV98xzNMEpN/RtWwy76lAVWNXZ37pikmx9s7j53Tx\noZq234DFAgMBAAECggEANEYFAYeqXRHJxl3tQ9GunN6VvrQkrqOdQFC7nK5YQCa5\naBb84SA8qHn3CP1Mec2miH4z/PxaWoREWJDKWvKEbfcmKv7EovNCM/8UlkrYiktf\noEmr6q2nC5RYuohePHugEgw3t9OY+pVJ3eGe4Ryl5G5d2c4/bNUYmfYfvbVubokG\nc2cee0YOr2axbaCWqv/Xkxog8ILiXp4L+VngG9ZbjHOSyZ+jm0acKBpqx2nwDE5m\nBcNcwvfuRmoGRI/RWQVV7d/o36rvkqXjfgsmidaDjEGUfvTYoD/sGWoNBf/h0RTG\nS19fOFTUgmkQEnAaKzcF5o4x7RiyyEMzzgks2Iu96wKBgQD2bPkE0/DUmXe6FkmH\nokDQay/eBj9Ia0KUAVi1UtwJAONIRCqnaMi5iGtiC+rYsvzZM7k9kbzm0ZiliXBL\nrONVfvXi1TpnuYfgXTHxgcz8rtycqcnHeRB2L2Gcy/U0Ojtky+mu6ntZSe93OiDP\nTfsTfx0kPkYBGUFheXCBvujTfwKBgQC/Y0tFLa1bovtkhSbrTNc3GQg0iwGkwXMd\nWj+J2XGoiJNNDsxeCg36RADFmjOGnfe9hYj8+BkmaSP2Hn/5fMjnWf+4UrRkGZqw\nrRksf67kYFoLQ0ov33PoBjDaCExR7JEyv0PDVKiBl3kTJTZvcLvN2Nkq4sJddI0y\n1XR+kHh9uwKBgQClW6CKHdIoR0cxBs2Wh0ko0hRPzy9d4CPP/0tQeWaPYBojnyJk\nLgsrfKBaLZcMjKbg9TVjXE0/MfxVcHF7RmtSLpy+9sh3W+cSplbiMXClSo1dTw3I\nnbNvKwI8XhyPTFgYnkCUEGJvGw7mmYn0seY+QfkDHgqJqDHYP85AMiQ37wKBgGbf\nnYb6zXMzQQPAGrJh5FDmcKWljmWb4h+F8h9LtS9M8jh6Wtm1d9vtD6kngMi8Qn0p\nuP+Y8BPYcg8KR+m37FmG49CVDAe+R4ruEFj97Oku7VeefNMMvkWahkm8KiHjEg0A\nCBGHgOffnqHu37q5EwnLpLfLmYQYcQlA+VRKnamfAoGAbro1q/iX6dCuVDZHS99z\nYd58cCbsecciuyEJlngYx5gtmxKnVd84l3g59SyuqdRhCfMSrn7NgARTCYf1ZBqG\nO6FV8sTdt2+sC2zkeWUj6Yob8IhLRfqQxwxiUHZQNBfGIEiySDJtzpXt1Aiwv6pP\nan3PZaIBY8bMA1WCu8muk5Y=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@qcute-c4d8f.iam.gserviceaccount.com",
      "client_id": "102699095661913449899",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40qcute-c4d8f.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    // Obtain the access token
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    // Close the HTTP client
    client.close();

    // Return the access token
    return credentials.accessToken.data;
  }
}
