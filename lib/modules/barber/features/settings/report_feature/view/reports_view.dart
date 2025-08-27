import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/widgets/custom_arrow_left.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/controller/report_controller.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/view/reports_view_body.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    Get.put(ReportController());

    return Scaffold(
      appBar: AppBar(
        title: Text('reports'.tr),
        leading: const CustomArrowLeft(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w, left: 15.w),
            child: SvgPicture.asset(
              AssetsData.reportsIcon,
            ),
          )
        ],
      ),
      body: ReportsViewBody(),
    );
  }
}
