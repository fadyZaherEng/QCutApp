import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_button.dart';
import 'package:q_cut/modules/customer/features/settings/notification_feature/logic/notification_view_controller.dart';

class NotificationViewBody extends StatelessWidget {
  const NotificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the view model for data
    final viewModel = Get.put(NotificationViewModel());

    return Obx(() {
      // Show loading indicator while fetching data
      if (viewModel.isLoading.value &&
          viewModel.displayedNotifications.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // Show error message if loading failed
      if (viewModel.isError.value && viewModel.displayedNotifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Failed to load notifications",
                  style: Styles.textStyleS14W700()),
              ElevatedButton(
                onPressed: viewModel.refreshNotifications,
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      }

      // Show empty state if no notifications
      if (viewModel.displayedNotifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No notifications available",
                  style: Styles.textStyleS14W700()),
              ElevatedButton(
                onPressed: viewModel.refreshNotifications,
                child: const Text("Refresh"),
              ),
            ],
          ),
        );
      }

      // Display notifications
      return RefreshIndicator(
        onRefresh: () async => viewModel.refreshNotifications(),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          itemCount: viewModel.displayedNotifications.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final notification = viewModel.displayedNotifications[index];
            return NotificationCard(
              notification: notification,
              viewModel: viewModel,
            );
          },
        ),
      );
    });
  }
}

class NotificationCard extends StatelessWidget {
  final dynamic notification;
  final NotificationViewModel viewModel;

  const NotificationCard({
    Key? key,
    required this.notification,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: ColorsData.cardColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32.r,
                foregroundImage: CachedNetworkImageProvider(
                  viewModel.getProfileImage(notification),
                ),
                backgroundColor: ColorsData.secondary,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.getNotificationTitle(notification),
                      style: Styles.textStyleS14W700(),
                    ),
                    Text(
                      viewModel.getNotificationMessage(notification),
                      style: Styles.textStyleS10W400(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Only show action buttons if notification has a process
          if (viewModel.hasActions(notification))
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    width: 138.w,
                    text: "Yes",
                    onPressed: () => viewModel.handleAppointmentConfirmation(
                        notification, true),
                  ),
                  CustomButton(
                    backgroundColor: ColorsData.cardStrock,
                    width: 138.w,
                    text: "No",
                    onPressed: () => viewModel.handleAppointmentConfirmation(
                        notification, false),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
