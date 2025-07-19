import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/bindings/initial_bindings.dart';
import 'package:q_cut/core/localization/change_local.dart';
import 'package:q_cut/core/localization/translation.dart';
import 'package:q_cut/core/services/shared_pref/pref_keys.dart';
import 'core/services/shared_pref/shared_pref.dart';
import 'core/utils/app_router.dart';
import 'core/utils/application_theme.dart';

class QCut extends StatelessWidget {
  const QCut({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    final localeController = Get.find<LocaleController>();

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          initialBinding: InitialBindings(),
          locale: localeController.language,
          fallbackLocale: const Locale('en'),
          translations: MyTranslation(),
          theme: getApplicationTheme(),
          initialRoute: SharedPref().getBool(PrefKeys.saveMe) ?? false
              ? AppRouter.bottomNavigationBar
              : AppRouter.initialPath,
          getPages: AppRouter.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
