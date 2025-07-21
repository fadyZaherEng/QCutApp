import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/widgets/connect_us_view_body.dart';

class ConnectUsView extends StatelessWidget {
  const ConnectUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "contact us".tr),
      body: const ConnectUsViewBody(),
    );
  }
}
