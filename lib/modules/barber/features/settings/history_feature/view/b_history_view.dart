import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/custom_b_drawer.dart';
import 'package:q_cut/modules/barber/features/settings/history_feature/controller/history_controller.dart';
import 'package:q_cut/modules/barber/features/settings/history_feature/view/b_history_view_body.dart';

class BHistoryView extends StatelessWidget {
  const BHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final historyController = Get.put(HistoryController());

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
