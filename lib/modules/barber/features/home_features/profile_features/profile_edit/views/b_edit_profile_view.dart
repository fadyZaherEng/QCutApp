import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';
import '../../../statistics_feature/views/widgets/ChooseOffDaysBottomSheet.dart';
import '../../profile_display/models/barber_profile_model.dart';
import '../logic/b_edit_profile_controller.dart';

class BEditProfileView extends StatelessWidget {
  const BEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure the controller is registered
    final controller = Get.isRegistered<BEditProfileController>()
        ? Get.find<BEditProfileController>()
        : Get.put(BEditProfileController());

    return Scaffold(
      backgroundColor: ColorsData.secondary,
      appBar: AppBar(
        backgroundColor: ColorsData.secondary,
        title: Text("Edit Profile".tr, style: Styles.textStyleS16W700()),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Photo Section
                    _buildTitle("Change Profile Photo".tr),
                    SizedBox(height: 16.h),
                    _buildProfilePhoto(controller),
                    SizedBox(height: 24.h),

                    // Cover Photo Section
                    _buildTitle("Change Cover Photo".tr),
                    SizedBox(height: 16.h),
                    _buildCoverPhoto(controller),
                    SizedBox(height: 32.h),

                    // Personal Details Section
                    _buildTitle("Change Your Details".tr),
                    SizedBox(height: 20.h),
                    _buildInputField("Change your name".tr, "Full Name".tr,
                        controller.nameController),
                    SizedBox(height: 16.h),
                    _buildInputField("Change Your Phone Number".tr,
                        "Phone Number".tr, controller.phoneController),
                    SizedBox(height: 16.h),
                    _buildInputField("Change Your Saloon Name".tr,
                        "Saloon Name".tr, controller.saloonController),
                    SizedBox(height: 16.h),
                    _buildInputField("Change Your City".tr, "City".tr,
                        controller.cityController),
                    SizedBox(height: 16.h),
                    _buildInputField("Change Your Bank Account".tr,
                        "Bank Account".tr, controller.bankAccountController),
                    SizedBox(height: 16.h),
                    _buildInputField("Change Your Instagram Page".tr,
                        "Instagram".tr, controller.instagramController),
                    _buildNoteText("It's not necessary if you haven't".tr),

                    SizedBox(height: 24.h),
                    Divider(thickness: 1.w, color: ColorsData.cardStrock),
                    SizedBox(height: 24.h),

                    // Off Days Section
                    _buildTitle("Set Your Off Days".tr),
                    SizedBox(height: 16.h),
                    _buildDropdownField("Select days when you don't work".tr,
                        () {
                      Get.bottomSheet(
                        ChooseOffDaysBottomSheet(
                          onDaysSelected: (selectedDays) {
                            // Get the current controller to use
                            final controller =
                                Get.find<BEditProfileController>();
                            // Update the controller with selected off days
                            controller.setOffDays(selectedDays);
                          },
                          selectedDays: Get.find<BEditProfileController>()
                              .offDays
                              .toList(),
                        ),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    }),
                    _buildNoteText(
                        "It's not necessary if you don't have off days".tr),

                    SizedBox(height: 32.h),

                    // Working Days Section
                    _buildTitle("Set Your Working Hours".tr),
                    SizedBox(height: 16.h),
                    _buildWorkingDaysSelector(controller),

                    SizedBox(height: 16.h),

                    // Confirm Button
                    _buildConfirmButton(controller),
                    SizedBox(height: 64.h),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(text,
        style: Styles.textStyleS14W700(color: ColorsData.primary));
  }

  Widget _buildProfilePhoto(BEditProfileController controller) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 90.r,
            height: 90.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: controller.getProfileImage,
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                  print('Error loading profile image: $exception');
                },
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => controller.pickProfileImage(),
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: ColorsData.primary,
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverPhoto(BEditProfileController controller) {
    return Container(
      height: 150.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        image: DecorationImage(
          image: controller.getCoverImage,
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            print('Error loading cover image: $exception');
          },
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: () => controller.pickCoverImage(),
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: ColorsData.primary,
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      String label, String hint, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Styles.textStyleS14W500(color: ColorsData.thirty)),
          SizedBox(height: 8.h),
          CustomTextFormField(
            fillColor: ColorsData.secondary,
            hintText: hint,
            controller: controller,
          ),
        ],
      ),
    );
  }

  // Off days selection widget
  Widget _buildDropdownField(String label, void Function()? onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Styles.textStyleS14W500(color: ColorsData.thirty)),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              border: Border.all(color: ColorsData.cardStrock),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(() {
                    final offDays = Get.find<BEditProfileController>().offDays;
                    return Text(
                      offDays.isEmpty
                          ? "Select off days".tr
                          : offDays.join(", "),
                      style: Styles.textStyleS14W400(
                          color: offDays.isEmpty ? Colors.grey : Colors.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  }),
                ),
                SizedBox(width: 8.w),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child:
          Text(text, style: Styles.textStyleS14W400(color: ColorsData.primary)),
    );
  }

  Widget _buildConfirmButton(BEditProfileController controller) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsData.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () {
          controller.updateProfile();
        },
        child: Text("Confirm".tr,
            style: Styles.textStyleS16W600(color: Colors.white)),
      ),
    );
  }

  // Create a new widget to handle working days selection
  Widget _buildWorkingDaysSelector(BEditProfileController controller) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Working Days Schedule".tr,
                    style: Styles.textStyleS14W500(color: Colors.white)),
                TextButton.icon(
                  onPressed: () => controller.addWorkingDay(),
                  icon: const Icon(Icons.add, color: ColorsData.primary),
                  label: Text("Add Day".tr,
                      style:
                          Styles.textStyleS12W500(color: ColorsData.primary)),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (controller.workingDays.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: ColorsData.cardColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: ColorsData.cardStrock),
                ),
                child: Center(
                  child: Text(
                    "No working days set. Add your working days.".tr,
                    style: Styles.textStyleS14W400(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.workingDays.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final workingDay = controller.workingDays[index];
                  return _buildWorkingDayItem(
                      controller, index, workingDay, context);
                },
              ),
          ],
        ));
  }

  // Widget to display a single working day with time selection
  Widget _buildWorkingDayItem(BEditProfileController controller, int index,
      WorkingDay workingDay, context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorsData.cardColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorsData.cardStrock),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Day dropdown
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  border:
                      Border.all(color: ColorsData.primary.withOpacity(0.5)),
                ),
                child: Obx(() {
                  // Get available days - exclude off days and already used working days (except current one)
                  final usedDays = controller.workingDays
                      .where((wd) => wd != workingDay)
                      .map((wd) => wd.day)
                      .toList();

                  final offDays = controller.offDays;

                  // Filter days to only show available ones - those not in usedDays and not in offDays
                  final availableDays = controller.availableDays
                      .where((day) =>
                          !usedDays.contains(day) && !offDays.contains(day) ||
                          day == workingDay.day)
                      .toList();

                  return DropdownButton<String>(
                    value: workingDay.day,
                    dropdownColor: ColorsData.secondary,
                    style: Styles.textStyleS14W500(color: Colors.white),
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: ColorsData.primary),
                    items: availableDays
                        .map((day) => DropdownMenuItem<String>(
                              value: day,
                              child: Text(day.tr),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateWorkingDay(
                            index,
                            WorkingDay(
                                day: value,
                                startHour: workingDay.startHour,
                                endHour: workingDay.endHour));
                      }
                    },
                  );
                }),
              ),

              // Delete button
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () => controller.removeWorkingDay(index),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              // Start time selector
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("From".tr,
                        style: Styles.textStyleS12W400(color: Colors.grey)),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () async {
                        final timeOfDay = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay(hour: workingDay.startHour, minute: 0),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: ColorsData.primary,
                                  onSurface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (timeOfDay != null) {
                          controller.updateWorkingDay(
                              index,
                              WorkingDay(
                                  day: workingDay.day,
                                  startHour: timeOfDay.hour,
                                  endHour: workingDay.endHour));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: ColorsData.secondary,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorsData.cardStrock),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time,
                                color: ColorsData.primary, size: 16),
                            SizedBox(width: 8.w),
                            Text(
                              "${workingDay.startHour}:00",
                              style:
                                  Styles.textStyleS14W400(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // End time selector
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("To".tr,
                        style: Styles.textStyleS12W400(color: Colors.grey)),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () async {
                        final timeOfDay = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay(hour: workingDay.endHour, minute: 0),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: ColorsData.primary,
                                  onSurface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (timeOfDay != null) {
                          controller.updateWorkingDay(
                              index,
                              WorkingDay(
                                  day: workingDay.day,
                                  startHour: workingDay.startHour,
                                  endHour: timeOfDay.hour));
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.h, horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: ColorsData.secondary,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorsData.cardStrock),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time,
                                color: ColorsData.primary, size: 16),
                            SizedBox(width: 8.w),
                            Text(
                              "${workingDay.endHour}:00",
                              style:
                                  Styles.textStyleS14W400(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
