import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';

class LocaleController extends GetxController {
  Locale? language;

  changeLang(String langcode) {
    Locale locale = Locale(langcode);
    SharedPref().setString("lang", langcode);
    Get.updateLocale(locale);
    update(); // Notify listeners about the change
  }

  String getCurrentLanguage() {
    return Get.locale?.languageCode ?? "en";
  }

  @override
  void onInit() {
    String? sharedPrefLang = SharedPref().getString("lang");
    if (sharedPrefLang == "ar") {
      language = const Locale("ar");
    } else if (sharedPrefLang == "en") {
      language = const Locale("en");
    } else if (sharedPrefLang == "he") {
      language = const Locale("he");
    } else {
      // Default to English if device locale is not supported
      String deviceLang = Get.deviceLocale?.languageCode ?? "en";
      if (["en", "ar", "he"].contains(deviceLang)) {
        language = Locale(deviceLang);
      } else {
        language = const Locale("en");
      }
    }
    Get.updateLocale(language!);
    super.onInit();
  }
}
