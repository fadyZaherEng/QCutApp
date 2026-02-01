import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/notification/notfication.dart';
import 'package:q_cut/core/services/shared_pref/pref_keys.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/b_appointment_view.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/models/barber_profile_model.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/logic/b_profile_controller.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/b_profile_view.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/widgets/custom_add_new_service_bottom_sheet.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/views/b_statics_view.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/home_view.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/view/my_appointment_view.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/views/my_profile_view.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../../core/utils/constants/assets_data.dart';
import '../../../core/utils/network/network_helper.dart';

class Deal {
  final String id;
  final int dealDateStart;
  final int dealDateEnd;
  final int qCuteSubscription;
  final int qCuteTax;
  final int freeDaysNumber;
  final String status;
  final String barber;
  final String createdAt;
  final String updatedAt;

  Deal({
    required this.id,
    required this.dealDateStart,
    required this.dealDateEnd,
    required this.qCuteSubscription,
    required this.qCuteTax,
    required this.freeDaysNumber,
    required this.status,
    required this.barber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
      id: json['_id'],
      dealDateStart: json['dealDateStart'],
      dealDateEnd: json['dealDateEnd'],
      qCuteSubscription: json['QCuteSubscription'],
      qCuteTax: json['QCuteTax'],
      freeDaysNumber: json['freeDaysNumber'],
      status: json['status'],
      barber: json['barber'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class DealResponse {
  final bool success;
  final List<Deal> deals;

  DealResponse({required this.success, required this.deals});

  factory DealResponse.fromJson(Map<String, dynamic> json) {
    return DealResponse(
      success: json['success'],
      deals:
          (json['deals'] as List).map((deal) => Deal.fromJson(deal)).toList(),
    );
  }
}

class MainController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  // Observable to hold the deal data
  final Rx<DealResponse?> dealResponse = Rx<DealResponse?>(null);
  final RxBool isLoadingDeal = false.obs;
  final RxString dealError = ''.obs;

  final List<Widget> pages = (SharedPref().getBool(PrefKeys.userRole)) == false
      ? [
          const BAppointmentView(),
          const BStaticsView(),
          const BProfileView(),
        ]
      : [
          const HomeView(),
          const MyAppointmentView(),
          const MyProfileView(),
        ];
  bool? isCustomer = SharedPref().getBool(PrefKeys.userRole);

  @override
  void onInit() async {
    super.onInit();
    if (isCustomer == false) {
      await fetchDealById();
    }
    await _notificationListener();
  }

  Future<void> _notificationListener() async {
    onNotificationClick?.stream.listen((event) {
      print("event MainController is $event");
      if (event.isNotEmpty) {
        print("event11111111111111111111 $event");
        _onNotificationClick(event);
      }
    });
  }

  // Method to fetch deal by ID
  Future<void> fetchDealById() async {
    isLoadingDeal.value = true;
    dealError.value = '';
    String? id = SharedPref().getString(PrefKeys.id);
    String? act = SharedPref().getString(PrefKeys.accessToken);
    print(act);
    try {
      final response = await _apiCall.getData(
        '${Variables.baseUrl}deal/$id',
      );

      print('${Variables.baseUrl}deal/$id');
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        dealResponse.value = DealResponse.fromJson(responseData);

        // Check if there's an accepted deal and show dialog
        if (dealResponse.value != null &&
            dealResponse.value!.deals.isNotEmpty &&
            dealResponse.value!.deals.any((deal) => deal.status == "pending")) {
          final pendingDeal = dealResponse.value!.deals
              .firstWhere((deal) => deal.status == "pending");

          showDealDialog(pendingDeal);
        } else if (dealResponse.value != null &&
            dealResponse.value!.deals.isNotEmpty &&
            dealResponse.value!.deals
                .any((deal) => deal.status == "accepted")) {
          // Show waiting dialog when no pending deal is found
        } else {
          // Show waiting dialog when API call fails
          showWaitingForOfferDialog();
        }
      }
    } catch (e) {
      dealError.value = 'Error fetching deal: $e';
      // Show waiting dialog when exception occurs
      showWaitingForOfferDialog();
    } finally {
      isLoadingDeal.value = false;
    }
  }

  // Method to show deal dialog
  void showDealDialog(Deal deal) {
    // Format dates for display
    String startDate = _formatDate(deal.dealDateStart);
    String endDate = _formatDate(deal.dealDateEnd);

    final TextStyle titleStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    final TextStyle subtitleStyle = TextStyle(
      fontSize: 16,
      color: Colors.black87,
    );

    final TextStyle boldGoldStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color(0xFFD1A439),
    );

    // Define the helper function here before using it
    Widget offerDetailRow(IconData icon, String text) {
      return Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF666666),
            size: 18.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                color: Color(0xFF444444),
              ),
            ),
          ),
        ],
      );
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 335.w,
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AssetsData.dealImage,
                width: 130.w,
                height: 130.h,
              ),
              SizedBox(height: 16.h),
              Text(
                "Thank you for choosing us".tr,
                style: titleStyle.copyWith(
                  fontSize: 18.sp,
                  color: Color(0xFF333333),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "QCut Special Offer".tr,
                style: subtitleStyle.copyWith(
                  fontSize: 17.sp,
                  color: Color(0xFFD1A439),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFEEEEEE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.celebration,
                            color: Color(0xFFD1A439), size: 20.sp),
                        SizedBox(width: 8.w),
                        Text("Exclusive Offer".tr, style: boldGoldStyle),
                      ],
                    ),
                    Divider(height: 24.h, color: Color(0xFFEEEEEE)),
                    offerDetailRow(
                      Icons.date_range,
                      "${"Valid Period".tr}: $startDate - $endDate",
                    ),
                    SizedBox(height: 10.h),
                    offerDetailRow(
                      Icons.money_off,
                      "${"QCut Tax:".tr} ${deal.qCuteTax}% per booking",
                    ),
                    SizedBox(height: 10.h),
                    offerDetailRow(
                      Icons.payment,
                      "${"Subscription".tr}: \$${deal.qCuteSubscription}",
                    ),
                    SizedBox(height: 10.h),
                    offerDetailRow(
                      Icons.card_giftcard,
                      "${"Free Trial".tr}: ${deal.freeDaysNumber} days",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        var response = await NetworkAPICall().editData(
                          '${Variables.baseUrl}deal',
                          {"status": "accepted"},
                        );

                        if (response.statusCode == 200) {
                          Get.back();

                          Get.snackbar(
                            "Success".tr,
                            "Offer accepted successfully".tr,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          
                          final BProfileController profileController =
                              Get.put(BProfileController());
                          await profileController.fetchProfileData();
                          await profileController.fetchBarberServices();

                          final profileData = profileController.profileData.value;

                          // Step 1: Navigate to Edit Profile page
                          final editProfileResult = await Get.toNamed(
                            AppRouter.beditProfilePath,
                            arguments: BarberProfileModel(
                              fullName: profileData?.fullName.trim() ?? '',
                              offDay: profileData?.offDay ?? [],
                              barberShop: profileData?.barberShop ?? '',
                              bankAccountNumber:
                                  profileData?.bankAccountNumber ?? '',
                              instagramPage: profileData?.instagramPage ?? '',
                              profilePic: profileData?.profilePic.trim() ?? '',
                              coverPic: profileData?.coverPic.trim() ?? '',
                              city: profileData?.city ?? 'New City',
                              workingDays: profileData?.workingDays ?? [],
                              barberShopLocation:
                                  profileData?.barberShopLocation ??
                                      BarberShopLocation(
                                          type: 'Point', coordinates: [0, 0]),
                              phoneNumber: profileData?.phoneNumber ?? '',
                            ),
                          );

                          // Step 2: Check if profile was updated
                          if (editProfileResult == true) {
                            await profileController.fetchProfileData();
                            final updatedProfileData = profileController.profileData.value;
                            
                            // Check if working days are set
                            if (updatedProfileData?.workingDays == null || 
                                updatedProfileData!.workingDays.isEmpty) {
                              // Show message and redirect back to edit profile
                              Get.snackbar(
                                "Set Working Days".tr,
                                "Please set your working days to continue".tr,
                                backgroundColor: Colors.orange,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 3),
                              );
                              
                              await Future.delayed(const Duration(seconds: 1));
                              
                              // Redirect back to edit profile
                              final workingDaysResult = await Get.toNamed(
                                AppRouter.beditProfilePath,
                                arguments: BarberProfileModel(
                                  fullName: updatedProfileData?.fullName.trim() ?? '',
                                  offDay: updatedProfileData?.offDay
                                      ?? [],
                                  barberShop: updatedProfileData?.barberShop??'',
                                  bankAccountNumber: updatedProfileData?.bankAccountNumber??'',
                                  instagramPage: updatedProfileData?.instagramPage??'',
                                  profilePic: updatedProfileData?.profilePic.trim()??'',
                                  coverPic: updatedProfileData?.coverPic.trim()??'',
                                  city: updatedProfileData?.city??'',
                                  workingDays: updatedProfileData?.workingDays??[],
                                  barberShopLocation: updatedProfileData?.barberShopLocation??
                                      BarberShopLocation(type: 'Point', coordinates: [0, 0]),
                                  phoneNumber: updatedProfileData?.phoneNumber??'',
                                ),
                              );
                              
                              if (workingDaysResult == true) {
                                await _checkAndForceAddService(profileController);
                              }
                            } else {
                              // Working days already set, check services
                              await _checkAndForceAddService(profileController);
                            }
                          }
                        } else {
                          Get.snackbar(
                            "Error".tr,
                            "Failed to accept the offer".tr,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD1A439),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        "Accept Offer".tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => {},
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF757575)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Contact Us".tr,
                        style: TextStyle(
                          color: Color(0xFF757575),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Method to show waiting for offer dialog
  void showWaitingForOfferDialog() {
    final TextStyle titleStyle = TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: Color(0xFF333333),
    );

    final TextStyle subtitleStyle = TextStyle(
      fontSize: 16.sp,
      color: Color(0xFF666666),
    );

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 335.w,
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Waiting icon/illustration

              // Clock or waiting animation
              Container(
                width: 130.w,
                height: 130.h,
                decoration: BoxDecoration(
                  color: Color(0xFFFAF6E9),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.access_time,
                    size: 60.sp,
                    color: Color(0xFFD1A439),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Please Wait",
                style: titleStyle,
              ),
              SizedBox(height: 10.h),
              Text(
                "QCut is preparing a special offer for you",
                textAlign: TextAlign.center,
                style: subtitleStyle,
              ),
              SizedBox(height: 8.h),
              Text(
                "We'll notify you once your offer is ready",
                textAlign: TextAlign.center,
                style: subtitleStyle.copyWith(
                  fontSize: 14.sp,
                  color: Color(0xFF888888),
                ),
              ),
              SizedBox(height: 24.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFEEEEEE)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFFD1A439),
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        "Our team is reviewing your application. You'll receive personalized terms shortly.",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD1A439),
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 30.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 50.h),
                  elevation: 2,
                ),
                child: Text(
                  "Got It",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // Helper method to format timestamp to readable date
  String _formatDate(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('MM/dd/yyyy').format(date);
  }

  void changePage(int index) {
    if (index >= 0 && index < pages.length) {
      currentIndex.value = index;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Helper method to check and force service addition
  Future<void> _checkAndForceAddService(BProfileController profileController) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Refresh services to get latest data
    await profileController.fetchBarberServices();
    
    if (profileController.barberServices.isEmpty) {
      // Navigate to profile page first
      Get.offAll(() => const BProfileView());
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Show a dialog explaining they need to add a service
      await Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Add Your First Service".tr),
            content: Text("You must add at least one service before customers can book appointments with you.".tr),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD1A439),
                ),
                onPressed: () async {
                  Get.back();
                  await Future.delayed(const Duration(milliseconds: 300));
                  
                  // Open add service bottom sheet in a non-dismissible way
                  await Get.bottomSheet(
                    WillPopScope(
                      onWillPop: () async {
                        // Check if at least one service has been added
                        await profileController.fetchBarberServices();
                        if (profileController.barberServices.isEmpty) {
                          Get.snackbar(
                            "Service Required".tr,
                            "Please add at least one service to continue".tr,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                          return false; // Prevent dismissing
                        }
                        return true; // Allow dismissing
                      },
                      child: const CustomAddNewServiceBottomSheet(),
                    ),
                    isDismissible: false,
                    enableDrag: false,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                    ),
                  );
                  
                  // After bottom sheet closes, verify service was added
                  await profileController.fetchBarberServices();
                  if (profileController.barberServices.isNotEmpty) {
                    Get.snackbar(
                      "Setup Complete".tr,
                      "Your profile is now ready! Customers can book appointments with you.".tr,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 5),
                    );
                  }
                },
                child: Text("Add Service".tr),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } else {
      // Services already exist, navigate to profile page and show success
      Get.offAll(() => const BProfileView());
      await Future.delayed(const Duration(milliseconds: 500));
      Get.snackbar(
        "Welcome!".tr,
        "Your profile is complete. You're ready to accept appointments!".tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  void _onNotificationClick(event) {
    // Handle navigation based on notification payload
    Get.toNamed(AppRouter.notificationPath);

    onNotificationClick?.add("");
  }
}
