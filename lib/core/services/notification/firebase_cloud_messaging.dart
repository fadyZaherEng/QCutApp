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
        "https://fcm.googleapis.com/v1/projects/enmaa-27811/messages:send",
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

  Future<String?> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "enmaa-27811",
      "private_key_id": "53de65d1b1e3a7e22c0e80fece44d9288003e421",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCkVTxFmv4gCVuh\n3bGmtE6CDAgGm7wbrHgm4nDKsKWcvZdwfETp1+ea60jGWbj0GEWGax/PHD8SpBFx\nzmF9eC90HoBhJn16xaf08pgyPX+H8CjvWnSospUBbmdEm9PydAavnC0m+nNq2G1Y\nBh9yr/8pdeFpp3UaJln0yjuxYlQCObJhvs4/YBmbu+nDbsUYGFzvn//zuTrmHt8s\n66DytjHT3d54cMF5a29AjFCXv6FJor6muhhptUnyX2OgJj3Ab9kuGETCXLN8+lZn\nSWgB0hDRrE7O9mMkpvtGNNV7maYO80cv2KR2E9ztquB8WXp0PTKNdj2drxPooWbc\nvy1peKW7AgMBAAECggEAORIA5It3Rdj6IbTERYjI2xEimGjtYw76i0aItVuzqEOP\nnFkL9cotfPfJRllSijMDsjLx0ROWM/sWs9dgtBpRIJqXKyYa3dBXDBJUGN6Ss7sL\n/FQFv7CFXwHgi0syyDjTOZmbdLX1711KXA+ETGgizVtK9U5atMIs635wTKJBWqPv\n+4GxNgS0XwYftJxxCTa4R1F51gTSk4c9qBTX607FTvObfPBI2SzUKt2NTsu6mqnn\nTrnR5dfQ8F3mjIU9KhLnh371waq/C+7IRkinm9aggYnwSSqLDR15WxXVUY2iu7EL\n3wYuMOBaqhaZ5U6dN+azKuNdam3UhlBOWTby8qVYQQKBgQDfZMXcWzFvEZeZ5gRS\n5+hAeRaOMw5OpSd3dAs+LCtJm1j2xqYfqjuooYlEjgB+lIpDHaN6qce6/ZTEuF16\nJcok0UFnyXRBstiNX0n1XXQ5mkjHKK4K1RA1HvAmXC94WVqqxCrNbdcl+zsvOnuB\nLMyxkWFuujH2hl8GbSykeLuwlwKBgQC8UaCHcgSeFIG6X5Lf5zcF5kZ8BCtpPERT\nqelLSdd5qHJuZF09Azj75OiuIzMyeO/J0ClqX6CjHDeC+87GIZ7CA1Ljzcz96DXk\n3mpe4qd8yDulqzMm0wwg2XFPkXqv5iTmBoQHixaFsvwFKrxhw+5a0HTQ5J862fi3\n+Lxrf4l0fQKBgCg2RpuM2tAodYahbgPSdO8uHM5KCHhFqF4LSH7Pipc8XH5Hcd3f\nUc/gDAqIGTSv3leIfUX2S9qwDNiAa2syZDnOZRyemcu9utdv4KtHQEWiLRmUjAet\nJLa7M/VjwLPEOdrlZuMFs6XFnHi66UJuYwZPqh85awb6Vx6cBl4w0XBPAoGAar2t\nyvgSq/OdsKEZpDXvVzW1//dxD74sUGu/o4AgVYHoErBqtPmNpCGUzZeAHny0FeUa\nhIPdjnag9Gp8Qout6/RsWFk/dy/W1HpJOq0oGC96t6W5YalAd6IoetxP+UHu6j8J\nOSlaQ8A230rg6l1fTjRX8kuUAYypUMX5LslkhRUCgYEAqbPM6rJe4PQ/khffLE7E\nDOI+ID+ndJSkM8dMNVWnxPiZXYUPLMooMiyf8wvq8pZPU5QJH0H2WHBmsa27F2mL\nsI8ZOn5RO4EIeiz/G9PYlhqDfbDiTA7dp2ad0wGfqeHx8U/6EMz9rE/C173BzSeu\nC+LfK1zuASN+0UMd7x+PFnw=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-suf60@enmaa-27811.iam.gserviceaccount.com",
      "client_id": "104850070626803636325",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-suf60%40enmaa-27811.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    try {
      http.Client client = await auth.clientViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

      auth.AccessCredentials credentials =
          await auth.obtainAccessCredentialsViaServiceAccount(
              auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
              scopes,
              client);

      client.close();

      return credentials.accessToken.data;
    } catch (e) {
      return null;
    }
  }
}
