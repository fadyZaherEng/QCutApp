import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/barber/features/settings/presentation/views/widgets/b_settings_view_body.dart';

class BSettingsView extends StatelessWidget {
  const BSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: CustomAppBar(title: "Settings".tr),
      body: BSettingViewBody(),
    );
  }
}
