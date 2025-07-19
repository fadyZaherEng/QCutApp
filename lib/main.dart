import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/localization/change_local.dart';
import 'package:q_cut/core/notification/firebase_cloud_messaging.dart';
import 'package:q_cut/core/notification/notfication.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/qcut_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/shared_pref/pref_keys.dart';

String profileImage = SharedPref().getString(PrefKeys.profilePic) ??
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzph4xv23B3sfc8O09BVewi1IeI-FWnHVvyxsnzqa6muN8-XWy08Vu0teNV7zXZrV1h8M&usqp=CAU";
String coverImage = SharedPref().getString(PrefKeys.coverPic) ??
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzph4xv23B3sfc8O09BVewi1IeI-FWnHVvyxsnzqa6muN8-XWy08Vu0teNV7zXZrV1h8M&usqp=CAU";

String fullName = SharedPref().getString(PrefKeys.fullName) ?? "Your Name";
String phoneNumber = SharedPref().getString(PrefKeys.phoneNumber) ?? "300300";

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref().instantiatePreferences();

  await Firebase.initializeApp(
    name: "QCut",
    options: const FirebaseOptions(
      apiKey: 'b9a71672bc185036ea63f8f992ede3746f74aba3',
      appId: '1:1050022864224:android:8e0ff4d00ace05ecbeaa05',
      messagingSenderId: '752059871954',
      projectId: 'qcute-c4d8f',
    ),
  ).then((value) async {
    // Setup services after Firebase has initialized
    await FirebaseCloudMessaging().init();
    await LocalNotificationService.init();
  }).catchError((error) {
    print('Failed to initialize Firebase: $error');
  });

  // Initialize the LocaleController after SharedPreferences
  Get.put(LocaleController(), permanent: true);

  // Run app
  runApp(const QCut());
}
