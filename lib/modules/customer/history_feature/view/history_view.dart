import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/modules/customer/history_feature/controller/history_controller.dart';
import 'package:q_cut/modules/customer/history_feature/view/history_view_body.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:   Text('History'.tr),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom:   TabBar(
            indicatorColor: ColorsData.primary,
            labelColor: ColorsData.font,
            unselectedLabelColor: ColorsData.font,
            tabs: [
              Tab(text: 'Previous'.tr),
              Tab(text: 'Currently'.tr),
            ],
          ),
        ),
        body: const HistoryViewBody(),
      ),
    );
  }
}
