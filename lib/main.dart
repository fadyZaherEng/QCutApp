import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/localization/change_local.dart';
import 'package:q_cut/core/notification/firebase_cloud_messaging.dart';
import 'package:q_cut/core/notification/notfication.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';
import 'package:q_cut/qcut_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/shared_pref/pref_keys.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';

String profileImage = SharedPref().getString(PrefKeys.profilePic) ??
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzph4xv23B3sfc8O09BVewi1IeI-FWnHVvyxsnzqa6muN8-XWy08Vu0teNV7zXZrV1h8M&usqp=CAU";
String coverImage = SharedPref().getString(PrefKeys.coverPic) ??
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzph4xv23B3sfc8O09BVewi1IeI-FWnHVvyxsnzqa6muN8-XWy08Vu0teNV7zXZrV1h8M&usqp=CAU";

String fullName = SharedPref().getString(PrefKeys.fullName) ?? "Your Name";
String phoneNumber = SharedPref().getString(PrefKeys.phoneNumber) ?? "300300";
String currentBarberId = SharedPref().getString(PrefKeys.barberId) ?? "";
String instagramLink = SharedPref().getString(PrefKeys.instagramLink) ??
    "https://www.instagram.com/";

String? barberJson = SharedPref().getString(PrefKeys.barber);

Barber currentBarber = barberJson != null
    ? Barber.fromJson(
        jsonDecode(SharedPref().getString(PrefKeys.barber) ?? "{}"))
    : Barber(
        id: currentBarberId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        userType: "barber",
        coverPic: coverImage,
        instagramPage: instagramLink,
        profilePic: profileImage,
        city: "",
        isFavorite: false,
        status: "active",
        offDay: [],
        workingDays: [],
      );

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPref().instantiatePreferences();

  // Initialize all supported locales (e.g., 'ar', 'en')
  await initializeDateFormatting();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
