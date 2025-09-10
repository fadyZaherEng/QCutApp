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

    // 🔥 الحالة المختارة للفلتر (افتراضي All)
    final RxString selectedFilter = 'all'.obs;
    //Get Language
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
                    originalList: controller.previousAppointments.toList().obs,
                    context: context,
                    selectedFilter: selectedFilter,
                  );
                } else {
                  return _buildFilterButton(
                    list: controller.currentAppointments,
                    originalList: controller.currentAppointments.toList().obs,
                    context: context,
                    selectedFilter: selectedFilter,
                  );
                }
              },
            ),
          ],
          bottom: TabBar(
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
              //change locale
              Tab(text: 'Currently'.tr),
              Tab(text: 'Previous'.tr),
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
    required RxString selectedFilter,
  }) {
    return Obx(() {
      return PopupMenuButton<String>(
        initialValue: selectedFilter.value, // 🔥 يحافظ على الاختيار الحالي
        onSelected: (value) {
          selectedFilter.value = value;
          controller.filterAppointments(
            value,
            isPrevious: DefaultTabController.of(context).index == 0,
          );
        },
        itemBuilder: (context) => [
          _buildMenuItem('all', 'All'.tr, selectedFilter.value),
          _buildMenuItem('completed', 'Completed'.tr, selectedFilter.value),
          _buildMenuItem('attended', 'Attended'.tr, selectedFilter.value),
          _buildMenuItem('cancelled', 'Cancelled'.tr, selectedFilter.value),
        ],
        icon: const Icon(Icons.filter_list),
      );
    });
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, String label, String selectedValue) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight:
                  selectedValue == value ? FontWeight.bold : FontWeight.normal,
              color: selectedValue == value ? ColorsData.primary : Colors.black,
            ),
          ),
          if (selectedValue == value) ...[
            const SizedBox(width: 6),
            const Icon(Icons.check, color: ColorsData.primary, size: 16),
          ],
        ],
      ),
    );
  }
}
