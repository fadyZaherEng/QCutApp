import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/custom_b_drawer.dart';
import 'package:q_cut/modules/barber/features/settings/history_feature/view/b_history_view_body.dart';

class BHistoryView extends StatelessWidget {
  const BHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'history'.tr,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        drawer: const CustomBDrawer(),
        body: const BHistoryViewBody(),
      ),
    );
  }
}
