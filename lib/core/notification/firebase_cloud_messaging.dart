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
      "private_key_id": "423a6523efdf5406d4e54bc7871a6452a7f6e9a8",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDOV2jwoSwptJGL\nai/5pnkNu/GGhn9klcO0+8pAAfQK5AmDpDS+04jSRLf50qcExRfFIx6gn3mG1ywy\nCNgR9/Cw3LThGPzFfUEcu6+bYWgLbLrc3x2MujuBYPxbAjMBRr2xHJYOaM9hkwzo\nxk1WLRwh++9itaApsmLDEiMCLUMhOPqQ/rhG5Il5Ah735m1tb9lVWDF2/57DE4Mq\nD4hWP4O7jg8u7OttewOfU9Di5nJCb4YcvO93Y2QZoerHFgmZYQEXZdDN3PjXRllx\nT4Jip9mtMy1NuQ4IJoDbH4TN4crfjq3HQmrhKW+/1J2gbsfD4qAXBeQKP6ihs6em\nwEN0HuUTAgMBAAECggEAPH5A3EcMKP/wqZRMk17cX4vpn7xfrdAAa9djsIdCEk1P\ngsIJ2qYulyKhY0MARzQ3J0sICCQo30DHCrYwDniHnnpeJx4JwSZbB/74WU/hznOm\nhul8gsz4dBJIea/33xhrtXiBf6D3p44Se03jz29zL31qbaB836yWKsVu8QzvANZp\ns92M1YSZPvgSJ5vmEpCRbkCzlcmLk5QWc5azq4igFwUR11G1Rq8ZVPcmAqkEWssx\nDhOHbxv4lY3Zu85XScRxjCs3EtoKcRNR6uSm2vjmMl4j/tsMIxCkFD1qyYeJRk7p\nRLHEd03XDWAnse5L06VjO1bHsQbt91qFCjr/LUVACQKBgQD8xCzSvyz07CXglunV\nLIM5V/bSGjNbFvetYXka9CDeA7IDaa09rpUafry7ZZqfEUqWZXsv4WXPD5q7Vqk6\nryePf/g4+1mFgnzL3DmNHwxjeI7Rf+WMB2YHdQMi4btgw77WnjT6vzXD2bFyL1Vs\n2Lm6jN9uW5BHeX2xZ2gpNzBKOQKBgQDQ+zDLPAEr8xWPzJjUQjHjwE0yDfOcoMtk\nKTzTqxCCS2TI9zMbNBjr1n7w9So1WiXuWLjguIOjgIMlzBRgN86HLMJ08im8gT7z\nWsks5z+yhQjKMW+C9fSrPtNA6b2jLxUfwuCPjmXu3MLeqv+aaHZNyIhqxcmHI9Ib\nW6aCM4vZqwKBgGJ5Gu1PxXf1uBvzL035dXYVqvbXdkJ6hCtr2f6CNXvI/MUPmop5\nRWV5EpX/U2m9Fs3Y41EYAs3USnfJn0xZiJQDSvUIFyxIVc4mEdXEztLB2QINTaRs\nDXfCQmKIhrOADw0VvZYigBO478SIZENve4wN7c3UpjTyQ+GlY5MLCSkhAoGAZbvi\n5Q0xBNQxiu9u9uXCo7zZ16QzE+yzFu98TQ7Z2pQZXDv7BSM3fpfM9EBla9OW45EN\nb1hjvRSyw5O116FTSTrg7010Q/AnVRC9Hr70o1NgFA482uQhV7wd21vulaI2BmA4\nMaqAtOeDdiKIjAKOlQ8qWdAvazpk7iyPwpKVYkECgYEAsAAK23/Qf2s3pnpl1jwn\nlhxLnDyLs8k8sLcESVH+APbjv+x/oJIQW2B2f0MMSaIwg3SZN2EhoPrbvJqAt62A\nZdeYPXMoFAl0yyH5XBVXBawxM2f2c7hxUrYncMUuyyCR3Bw9wwafAgyPiuHCebM7\nxoLXUq358QoiWbYzfB2qEhw=\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fbsvc@qcute-c4d8f.iam.gserviceaccount.com",
      "client_id": "102699095661913449899",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40qcute-c4d8f.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    }
    ;

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
