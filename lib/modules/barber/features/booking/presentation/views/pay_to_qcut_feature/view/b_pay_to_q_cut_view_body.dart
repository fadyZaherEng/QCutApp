import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading.value) {
        return const Center(
            child: SpinKitDoubleBounce(color: ColorsData.primary));
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            _buildHeaderSection(),
            SizedBox(height: 20.h),
            _buildInvoiceDetailsCard(),
            SizedBox(height: 20.h),
            Obx(() {
              // Check if there's at least one unpaid invoice
              final hasUnpaidInvoice =
                  _controller.invoices.value.any((invoice) => !invoice.isPaid);

              if (hasUnpaidInvoice) {
                // Find the first unpaid invoice to get its ID
                final unpaidInvoice = _controller.invoices.value.firstWhere(
                  (invoice) => !invoice.isPaid,
                  orElse: () => _controller.invoices.value.first,
                );

                return CustomBigButton(
                  textData: "continueToPay".tr,
                  onPressed: () {
                    Get.toNamed(AppRouter.bpaymentMethodsPath,
                        arguments: unpaidInvoice.id);
                  },
                );
              } else if (_controller.invoices.value.isEmpty) {
                return CustomBigButton(
                  textData: "noPaymentsRequired".tr,
                  onPressed: null,
                );
              } else {
                // Return an empty SizedBox if all invoices are paid
                return const SizedBox();
              }
            }),
            SizedBox(height: 20.h),
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
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Center(
          child: Text(
            "checkSubscription".tr,
            style: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildInvoiceDetailsCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: ColorsData.cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildJoinedSection(),
          SizedBox(height: 16.h),
          _buildPaymentTimelineSection(),
        ],
      ),
    );
  }

  Widget _buildJoinedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'timeToJoinedQcut'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(color: Colors.white24, height: 16.h),
        _buildInfoRow('dateToJoined'.tr, _controller.getJoinDate()),
        _buildInfoRow('joinedSince'.tr, _controller.getJoinedSince(),
            highlight: true),
      ],
    );
  }

  Widget _buildPaymentTimelineSection() {
    final paymentTimeline = _controller.getPaymentTimeline();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'paymentTimeLine'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        ...List.generate(
          paymentTimeline.length,
          (index) => _buildPaymentItem(
            index,
            paymentTimeline[index]['date'],
            paymentTimeline[index]['status'],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              if (isClicked) {
                isClicked = false;
                setState(() {});
                Get.toNamed(AppRouter.bpaymentTimeLinePath);
                Future.delayed(const Duration(seconds: 2), () {
                  isClicked = true;
                  setState(() {});
                });
              }
            },
            child: Text(
              'seeAll'.tr,
              style: TextStyle(color: ColorsData.primary, fontSize: 12.sp),
            ),
          ),
        ),
      ],
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

  Widget _buildPaymentItem(int index, String date, String status) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            AssetsData.calendarIcon,
            height: 16.h,
            width: 16.w,
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
                  status.toLowerCase().contains("paid")
                      ? 'paid'.tr
                      : 'unpaid'.tr,
                  style: TextStyle(
                    color: _controller.isPaidList[index]
                        ? Colors.white
                        : Colors.white70,
                    fontSize: 12.sp,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _controller.isPaidList[index]
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: _controller.isPaidList[index]
                  ? ColorsData.primary
                  : Colors.white70,
              size: 18.sp,
            ),
            onPressed: () {},
            constraints: BoxConstraints(
              minWidth: 36.w,
              minHeight: 36.h,
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
