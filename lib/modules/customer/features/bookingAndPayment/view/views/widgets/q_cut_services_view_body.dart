import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/customer/features/bookingAndPayment/view/views/widgets/q_cut_service_card.dart';
import 'package:q_cut/modules/customer/features/bookingAndPayment/logic/q_cut_services_controller.dart';

class QCutServicesViewBody extends StatelessWidget {
  const QCutServicesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QCutServicesController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "${'services'.tr} ",
                  style: Styles.textStyleS16W700(color: Colors.white),
                ),
                Text(
                  "(${controller.barberServices.length} ${'servicesCount'.tr})",
                  style: Styles.textStyleS14W700(color: ColorsData.primary),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: .74,
                ),
                itemCount: controller.barberServices.length,
                itemBuilder: (context, index) {
                  final service = controller.barberServices[index];
                  return QCutServiceCard(
                    service: service,
                    isSelected: controller.selectedServices[index],
                    onPressed: () => controller.toggleService(index),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            CustomBigButton(
              textData: "confirm".tr,
              onPressed: () {
                Get.toNamed(AppRouter.bookAppointmentPath);
              },
            ),
          ],
        );
      }),
    );
  }
}
