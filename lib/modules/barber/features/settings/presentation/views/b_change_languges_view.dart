import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/barber/features/settings/presentation/views/widgets/b_change_languges_view_body.dart';

class BChangeLangugesView extends StatelessWidget {
  const BChangeLangugesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'changeLangauges'.tr,
        onPressed: () {
          Get.toNamed(AppRouter.settingsPath);
        },
      ),
      body: const BChangeLangugesViewBody(),
    );
  }
}
