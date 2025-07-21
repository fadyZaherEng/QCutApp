import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/show_delete_appointment_dialog.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/logic/appointment_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/view/widgets/custom_delete_appointment_item.dart';

class MyAppointmentView extends StatelessWidget {
  const MyAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerAppointmentController());

    // Add this to refresh when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshAppointments();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("myAppointments".tr),
        actions: [
          _buildFilterButton(controller),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshAppointments(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: SpinKitDoubleBounce(
                color: ColorsData.primary,
              ),
            );
          } else if (controller.isError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.errorMessage.value,
                    style: Styles.textStyleS14W400(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () => controller.fetchAppointments(),
                    child: Text('Retry'.tr),
                  ),
                ],
              ),
            );
          } else if (controller.filteredAppointments.isEmpty) {
            return Center(
              child: Text(
                'noAppointmentsFound'.tr,
                style: Styles.textStyleS14W400(),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: controller.filteredAppointments.length,
              itemBuilder: (context, index) {
                final appointment = controller.filteredAppointments[index];
                return CustomDeleteAppointmentItem(
                  appointment: appointment,
                  onDelete: () {
                    showDeleteAppointmentDialog(
                      context: context,
                      onYes: () async {
                        final success =
                            await controller.deleteAppointment(appointment.id);
                        if (success && context.mounted) {
                          Get.back();
                        }
                      },
                      onNo: () {
                        Get.back();
                      },
                    );
                  },
                );
              },
            );
          }
        }),
      ),
    );
  }

  Widget _buildFilterButton(CustomerAppointmentController controller) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        controller.setStatusFilter(value);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'all',
          child: Text('allAppointments'.tr),
        ),
        PopupMenuItem(
          value: 'pending',
          child: Text('Pending'.tr),
        ),
        PopupMenuItem(
          value: 'cancelled',
          child: Text('Cancelled'.tr),
        ),
        PopupMenuItem(
          value: 'NotCome',
          child: Text('Not Attended'.tr),
        ),
        PopupMenuItem(
          value: 'completed',
          child: Text('Completed'.tr),
        ),
      ],
      icon: const Icon(Icons.filter_list),
    );
  }
}
