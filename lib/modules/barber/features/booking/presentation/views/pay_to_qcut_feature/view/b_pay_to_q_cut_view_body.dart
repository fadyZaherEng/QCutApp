import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/barber/features/booking/presentation/views/pay_to_qcut_feature/logic/pay_to_qcut_controller.dart';

class BPayToQCutViewBody extends StatefulWidget {
  const BPayToQCutViewBody({super.key});

  @override
  State<BPayToQCutViewBody> createState() => _BPayToQCutViewBodyState();
}

class _BPayToQCutViewBodyState extends State<BPayToQCutViewBody> {
  final PayToQcutController _controller = Get.put(PayToQcutController());
  bool isClicked = true;
  int _selectedTab = 1; // 0 for Previous, 1 for Currently (setting 1 as default to match left image)

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(
          child: SpinKitDoubleBounce(color: ColorsData.primary),
        );
      }

      if (_controller.isError.value) {
        return _buildErrorWidget();
      }

      return RefreshIndicator(
        onRefresh: _controller.fetchInvoiceData,
        color: ColorsData.primary,
        child: _buildMainContent(),
      );
    });
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'errorLoadingData'.tr,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              _controller.errorMessage.value,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsData.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              if (isClicked) {
                isClicked = false;
                setState(() {});
                _controller.fetchInvoiceData();
                await Future.delayed(const Duration(seconds: 2), () {
                  isClicked = true;
                  setState(() {});
                });
              }
            },
            child: Text('retry'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            _buildHeaderSection(),
            SizedBox(height: 30.h),
            _buildPaymentCard(),
            SizedBox(height: 30.h),
            _buildActionButtons(),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Center(
          child: Image.asset(
            AssetsData.thanksImage,
            width: 183.w,
            height: 137.h,
          ),
        ),
        SizedBox(height: 20.h),
        Center(
          child: Text(
            'weAreGlad'.tr,
            style: TextStyle(
              color: ColorsData.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Center(
          child: Text(
            "checkSubscription".tr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsData.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Text(
            "monthly payment is 200\$!",
            style: TextStyle(
              color: ColorsData.primary,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _buildTabItem("Previous Payments", 0),
              _buildTabItem("Currently Payments", 1),
            ],
          ),
          SizedBox(height: 20.h),
          _selectedTab == 0 ? _buildPreviousPaymentsList() : _buildCurrentlyPaymentsGrid(),
        ],
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Container(
              height: 2.h,
              width: 80.w,
              color: isSelected ? ColorsData.primary : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviousPaymentsList() {
    final payments = _controller.getPaymentTimeline();

    if (payments.isEmpty || (payments.length == 1 && payments[0]['date'] == 'No data')) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Text(
          "No previous payments found",
          style: TextStyle(color: Colors.white70, fontSize: 13.sp),
        ),
      );
    }

    return Column(
      children: payments.map((payment) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  payment['date'],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${payment['amount']} LE",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCurrentlyPaymentsGrid() {
    // Current month first and second day
    DateTime now = DateTime.now();
    DateTime firstDay = DateTime(now.year, now.month, 1);
    DateTime secondDay = DateTime(now.year, now.month, 2);

    String firstDayName = DateFormat('EEEE').format(firstDay);
    String secondDayName = DateFormat('EEEE').format(secondDay);

    return Row(
      children: [
        Expanded(child: _buildCurrentPaymentCard(firstDayName)),
        SizedBox(width: 15.w),
        Expanded(child: _buildCurrentPaymentCard(secondDayName)),
      ],
    );
  }

  Widget _buildCurrentPaymentCard(String day) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "17:00 - 20:00",
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Obx(() {
      // Check if there's at least one unpaid invoice
      final hasUnpaidInvoice =
          _controller.invoices.value.any((invoice) => !invoice.isPaid);

      if (hasUnpaidInvoice) {
        final unpaidInvoice = _controller.invoices.value.firstWhere(
          (invoice) => !invoice.isPaid,
          orElse: () => _controller.invoices.value.first,
        );

        return CustomBigButton(
          textData: "Confirm", // Using "Confirm" as per the image
          onPressed: () {
            Get.toNamed(AppRouter.bpaymentMethodsPath,
                arguments: unpaidInvoice.id);
          },
        );
      } else {
        return CustomBigButton(
          textData: "Confirm",
          onPressed: () {
            // Even if no unpaid, we can allow clicking or show feedback
          },
        );
      }
    });
  }
}
