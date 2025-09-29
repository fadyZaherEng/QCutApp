import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/widgets/custom_arrow_left.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/controller/report_controller.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/view/reports_view_body.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final reportController = Get.put(ReportController());

    return Scaffold(
      appBar: AppBar(
        title: Text('reports'.tr),
        leading: const CustomArrowLeft(),
        actions: [
          // Existing reports icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SvgPicture.asset(
              AssetsData.reportsIcon,
              height: 26,
              width: 26,
            ),
          ),

          // ✅ Filter Button as Image
          GestureDetector(
            onTap: () async {
              // Open date range picker or your custom filter
              // final DateTimeRange? picked = await showDateRangePicker(
              //   context: context,
              //   firstDate: DateTime(2023),
              //   lastDate: DateTime(2030),
              //   initialDateRange: DateTimeRange(
              //     start: DateTime.now(),
              //     end: DateTime.now(),
              //   ),
              // );
              //
              // if (picked != null) {
              //   reportController.selectedStartDate.value = picked.start;
              //   reportController.selectedEndDate.value = picked.end;
              //   reportController.fetchReports(); // Refresh reports with filter
              // }
              reportController.showDatePickerAndSearch(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SvgPicture.asset(
                AssetsData
                    .sortIcon, // <-- Make sure you have a filter icon in assets
                height: 26,
                width: 26,
                color: ColorsData.primary,
              ),
            ),
          ),
        ],
      ),
      body: const ReportsViewBody(),
    );
  }
}
