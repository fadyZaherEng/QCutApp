// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/main.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/custom_b_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/constants/constants.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/logic/appointment_controller.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/custom_b_appointment_app_bar.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/custom_b_appointment_list_item.dart';
import 'picker.dart';

class BAppointmentView extends StatelessWidget {
  const BAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BAppointmentController());

    return SafeArea(
      child: Scaffold(
        drawer: const CustomBDrawer(),
        body: RefreshIndicator(
          onRefresh: () => controller.refreshAppointments(),
          child: Obx(
            () {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h),
                      child: Column(
                        children: [
                          const CustomBAppointmentAppBar(),
                          SizedBox(height: 16.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 32.r,
                                foregroundImage:
                                    CachedNetworkImageProvider(profileImage),
                                backgroundColor: ColorsData.secondary,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                controller.barberName,
                                style: Styles.textStyleS14W700(),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                controller.barberServices,
                                style: Styles.textStyleS12W400(),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          const Divider(
                            color: ColorsData.cardStrock,
                          ),
                          SizedBox(height: 12.h),
                          CustomDaysPicker(
                            titleSimpleDaysPicker: "myAppointments".tr,
                            selectedDay: controller.selectedDay.value,
                            onDaySelected: (day) =>
                                controller.changeSelectedDay(day),
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                  if (controller.isLoading.value)
                    const SliverToBoxAdapter(
                      child: Center(
                        child: SpinKitDoubleBounce(color: ColorsData.primary),
                      ),
                    ),
                  if (!controller.isLoading.value &&
                      controller.appointments.isEmpty)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: Column(
                            children: [
                              Text(
                                "noAppointmentsFound".tr,
                                style: Styles.textStyleS14W500(),
                              ),
                              if (controller.isError.value)
                                Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    "Error: ${controller.errorMessage.value}",
                                    style: Styles.textStyleS12W400()
                                        .copyWith(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (!controller.isLoading.value &&
                      controller.appointments.isNotEmpty &&
                      controller.filteredAppointments.isEmpty)
                    SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 50.h),
                          child: Text(
                            "noAppointmentsForThisDay".tr,
                            style: Styles.textStyleS14W500(),
                          ),
                        ),
                      ),
                    ),
                  if (!controller.isLoading.value &&
                      controller.filteredAppointments.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: controller.filteredAppointments.length,
                        (context, index) {
                          final appointment =
                              controller.filteredAppointments[index];

                          print("appointment item # $index:${appointment.id}");

                          // Load more when reaching the end of the list
                          if (index ==
                              controller.filteredAppointments.length - 1) {
                            print("Reached last item, loading more");
                            controller.loadMoreAppointments();
                          }

                          return Padding(
                            padding: EdgeInsets.only(
                                left: 16.w, right: 16.w, bottom: 12.h),
                            child: CustomBAppointmentListItem(
                              id: appointment.id,
                              onDeleteTap: () => controller
                                  .didntComeAppointment(appointment.id),
                              imageUrl: profileDrawerImage,
                              name: appointment.user.fullName,
                              controller: controller,
                              appointment: appointment,
                              location: "location".tr,
                              service: appointment.services.isNotEmpty
                                  ? appointment.services[0].service.name
                                  : "service".tr,
                              hairStyle: appointment.runtimeType.toString(),
                              qty: "${appointment.services.length}",
                              bookingDay: appointment.formattedDate,
                              bookingTime: appointment.formattedTime,
                              type: appointment.status,
                              price: appointment.price,
                              finalPrice: appointment.price,
                              services: appointment.services,
                            ),
                          );
                        },
                      ),
                    ),
                  if (controller.isLoadingMore.value)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.h),
                        child: const Center(
                          child: SpinKitDoubleBounce(color: ColorsData.primary),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
          onPressed: () {
            // controller.openAddAppointmentDialog();
            Get.toNamed(AppRouter.selectedPath, arguments: currentBarber);
          },
          backgroundColor: ColorsData.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
