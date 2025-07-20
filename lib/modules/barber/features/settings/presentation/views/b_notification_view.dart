import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/barber/features/settings/presentation/views/widgets/b_notification_view_body.dart';

class BNotificationView extends StatelessWidget {
  const BNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Notifications".tr),
      body: BNotificationViewBody(),
    );
  }
}
