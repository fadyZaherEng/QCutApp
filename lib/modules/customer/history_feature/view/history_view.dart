import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/modules/customer/history_feature/controller/history_controller.dart';
import 'package:q_cut/modules/customer/history_feature/view/history_view_body.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    // 🔥 اعمل نسخة أصلية من المواعيد (مرة واحدة)
    final RxList previousOriginal =
        controller.previousAppointments.toList().obs;
    final RxList currentOriginal = controller.currentAppointments.toList().obs;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'.tr),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Builder(
              builder: (context) {
                final tabController = DefaultTabController.of(context);
                if (tabController.index == 0) {
                  return _buildFilterButton(
                    list: controller.previousAppointments,
                    originalList: previousOriginal,
                    context: context,
                  );
                } else {
                  return _buildFilterButton(
                    list: controller.currentAppointments,
                    originalList: currentOriginal,
                    context: context,
                  );
                }
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: ColorsData.primary,
            labelColor: ColorsData.font,
            unselectedLabelColor: ColorsData.font,
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            unselectedLabelStyle:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            dividerColor: Colors.white,
            dividerHeight: 1,
            tabs: [
              Tab(text: 'Previous'),
              Tab(text: 'Currently'),
            ],
          ),
        ),
        body: HistoryViewBody(
          currentAppointments: controller.currentAppointments,
          previousAppointments: controller.previousAppointments,
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required RxList list,
    required RxList originalList,
    required BuildContext context,
  }) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        controller.filterAppointments(
          value,
          isPrevious: DefaultTabController.of(context).index == 0,
        );
      },
      itemBuilder: (context) => [
        PopupMenuItem(value: 'all', child: Text('All'.tr)),
        PopupMenuItem(value: 'completed', child: Text('Completed'.tr)),
        PopupMenuItem(value: 'attended', child: Text('Attended'.tr)),
        PopupMenuItem(value: 'cancelled', child: Text('Cancelled'.tr)),
      ],
      icon: const Icon(Icons.filter_list),
    );
  }
}
