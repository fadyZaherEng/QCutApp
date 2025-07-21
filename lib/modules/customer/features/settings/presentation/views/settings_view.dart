import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/widgets/settings_view_body.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Settings".tr),
      body: SettingViewBody(),
    );
  }
}
