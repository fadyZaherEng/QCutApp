import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';

class BPaymentTimeLineViewBody extends StatefulWidget {
  const BPaymentTimeLineViewBody({super.key});

  @override
  _BPaymentTimeLineViewBodyState createState() =>
      _BPaymentTimeLineViewBodyState();
}

class _BPaymentTimeLineViewBodyState extends State<BPaymentTimeLineViewBody> {
  List<bool> isPaidList = [true, true, true, true, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "checkSubscription".tr,
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: ColorsData.cardColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("timeToJoinedQcut".tr),
                _buildInfoRow("dateToJoined".tr, "1/1/2024"),
                _buildInfoRow("joinedSince".tr, "3 ${"months".tr}",
                    highlight: true),
                Divider(color: Colors.white24, height: 16.h),
                _buildSectionTitle("paymentTimeLine".tr),
                SizedBox(height: 8.h),
                ..._buildPaymentItems(),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          CustomBigButton(
            textData: "continueToPay".tr,
            onPressed: () {
              Get.toNamed(AppRouter.bpaymentMethodsPath);
            },
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: ColorsData.primary,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, {bool highlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? ColorsData.primary : Colors.white,
              fontSize: 12.sp,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPaymentItems() {
    List<Map<String, String>> payments = [
      {'date': '1/1/2024', 'status': 'paid'.tr},
      {'date': '1/2/2024', 'status': 'paid'.tr},
      {'date': '1/2/2024', 'status': 'paid'.tr},
      {'date': '1/2/2024', 'status': 'paid'.tr},
      {'date': '1/3/2024', 'status': 'unpaid'.tr},
    ];

    return List.generate(payments.length, (index) {
      return _buildPaymentItem(
          index, payments[index]['date']!, payments[index]['status']!);
    });
  }

  Widget _buildPaymentItem(int index, String date, String status) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            height: 16.h,
            width: 16.w,
            AssetsData.calendarIcon,
            colorFilter: const ColorFilter.mode(
              ColorsData.primary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  date,
                  style: TextStyle(color: Colors.white, fontSize: 12.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  status,
                  style: TextStyle(
                    color: isPaidList[index] ? Colors.white : Colors.white70,
                    fontSize: 12.sp,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            icon: Icon(
              isPaidList[index]
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: isPaidList[index] ? ColorsData.primary : Colors.white70,
              size: 18.sp,
            ),
            onPressed: () {
              setState(() {
                isPaidList[index] = !isPaidList[index];
              });
            },
          ),
        ],
      ),
    );
  }
}
