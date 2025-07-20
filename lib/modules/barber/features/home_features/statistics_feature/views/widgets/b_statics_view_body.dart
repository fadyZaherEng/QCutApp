import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/controller/statistics_controller.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/views/widgets/CustomTimeSelectDialog.dart';

class BStaticsViewBody extends StatelessWidget {
  const BStaticsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final StatisticsController controller = Get.put(StatisticsController());

    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshAllStats();
      },
      color: ColorsData.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('allAboutYourSalon'.tr,
                    style: Styles.textStyleS14W600(color: Colors.white)
                        .copyWith(
                            fontWeight: FontWeight.w700, fontSize: 13.sp)),
                GestureDetector(
                  onTap: () {
                    showCustomTimeSelectDialog(context,
                        onTimeSelected: (timeFrame) {
                      controller.updateTimeFrame(timeFrame);
                    });
                  },
                  child: SvgPicture.asset(
                    height: 33.h,
                    width: 33.w,
                    AssetsData.sortIcon,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Obx(() => controller.isStatsLoading.value
                ? Center(
                    child: SpinKitDoubleBounce(
                      color: ColorsData.primary,
                    ),
                  )
                : _buildStatisticsCards(controller)),
            SizedBox(height: 20.h),
            Text('allPaymentMethods'.tr,
                style: Styles.textStyleS14W600(color: Colors.white)),
            SizedBox(height: 10.h),
            _buildPaymentMethods(),
            SizedBox(height: 20.h),
            _buildBookingChart(),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(StatisticsController controller) {
    List<Map<String, dynamic>> stats = [
      {
        'title': 'allAppointments'.tr,
        'value': controller.barberStats.value.totalAppointments.toString(),
        'unit': 'appointment'.tr,
        'svgImagePath': AssetsData.calendarIcon,
      },
      {
        'title': 'workingHours'.tr,
        'value': controller.barberStats.value.workingHours.toString(),
        'unit': 'hours'.tr,
        'svgImagePath': AssetsData.clockIcon,
      },
      {
        'title': 'allIncome'.tr,
        'value': controller.barberStats.value.totalIncome.toStringAsFixed(0),
        'unit': '\$',
        'svgImagePath': AssetsData.calendarIcon,
      },
      {
        'title': 'incomeHr'.tr,
        'value': controller.formattedIncomePerHour,
        'unit': '\$',
        'svgImagePath': AssetsData.notificationsIcon,
      },
      {
        'title': 'allConsumers'.tr,
        'value': controller.totalConsumers.toString(),
        'unit': 'consumers'.tr,
        'svgImagePath': AssetsData.calendarIcon,
      },
      {
        'title': 'NewConsumers'.tr,
        'value': controller.barberStats.value.newConsumers.toString(),
        'unit': 'consumers'.tr,
        'svgImagePath': AssetsData.profileIcon,
      },
    ];

    return Container(
      width: 348.w,
      height: 192.h,
      decoration: BoxDecoration(
        color: const Color(0xFF5A5679),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xAAAAAAAA), width: 1),
      ),
      padding: EdgeInsets.all(8.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 104 / 85,
        ),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return _buildStatCard(
            stats[index]['title']!,
            stats[index]['value']!,
            stats[index]['unit']!,
            stats[index]['svgImagePath']!,
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String unit, String svgImagePath) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 13.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.5, -0.5),
          end: Alignment(1, 1),
          colors: [Color(0xFF1F1E25), Color(0xFF5A5679)],
          stops: [0.2826, 0.912],
          transform: GradientRotation(126.97 * 3.14159 / 180),
        ),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            height: 16.h,
            width: 16.w,
            svgImagePath,
            colorFilter: const ColorFilter.mode(
              ColorsData.primary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            style: Styles.textStyleS12W400(color: ColorsData.primary).copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5.h),
          FittedBox(
            child: Row(
              children: [
                Text(
                  value,
                  style: Styles.textStyleS12W700(color: Colors.white),
                ),
                Text(
                  ' $unit',
                  style: Styles.textStyleS8W400(color: ColorsData.thirty),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final StatisticsController controller = Get.find<StatisticsController>();

    return Obx(() => controller.isPaymentStatsLoading.value
        ? Center(
            child: SpinKitDoubleBounce(
              color: ColorsData.primary,
            ),
          )
        : SizedBox(
            width: 348.w,
            height: 106.h,
            child: Row(
              children: [
                Expanded(
                  child: _buildPaymentCard(
                    'allPaymentMethods'.tr,
                    controller.paymentStats.value.totalPayments.toString(),
                    'process'.tr,
                    showProgress: false,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildPaymentCard(
                    'cashMethod'.tr,
                    '${controller.paymentStats.value.cashPercentage.toStringAsFixed(0)}%',
                    'process'.tr,
                    progressValue:
                        controller.paymentStats.value.cashPercentage / 100,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildPaymentCard(
                    'visaMethod'.tr,
                    '${controller.paymentStats.value.visaPercentage.toStringAsFixed(0)}%',
                    'process'.tr,
                    progressValue:
                        controller.paymentStats.value.visaPercentage / 100,
                  ),
                ),
              ],
            ),
          ));
  }

  Widget _buildPaymentCard(String title, String value, String subtitle,
      {double? progressValue, bool showProgress = true}) {
    return Container(
      width: 109.w,
      height: 106.h,
      padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 8.h),
      decoration: BoxDecoration(
        color: ColorsData.cardColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          if (title == 'allPaymentMethods'.tr)
            Column(
              children: [
                SvgPicture.asset(
                  AssetsData.dollarIcon,
                  height: 16.h,
                  width: 16.w,
                  colorFilter: const ColorFilter.mode(
                    ColorsData.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          Text(
            title,
            style: Styles.textStyleS12W400(color: Colors.white).copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
          if (showProgress && progressValue != null)
            Column(
              children: [
                SizedBox(height: 5.h),
                CircularPercentIndicator(
                  radius: 24.w,
                  lineWidth: 4.0,
                  percent: progressValue,
                  backgroundColor: ColorsData.beige.withOpacity(0.2),
                  progressColor: ColorsData.primary,
                  circularStrokeCap: CircularStrokeCap.round,
                  startAngle: 270,
                  animation: true,
                  animateFromLastPercent: true,
                  center: Text(
                    value,
                    style: Styles.textStyleS12W700(color: Colors.white)
                        .copyWith(fontSize: 11.sp),
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: Styles.textStyleS12W700(color: Colors.white).copyWith(),
            ),
          SizedBox(height: 8.h),
          Text(
            subtitle,
            style: Styles.textStyleS8W400(color: ColorsData.thirty),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingChart() {
    final StatisticsController controller = Get.find<StatisticsController>();

    return Obx(() => controller.isMonthlyStatsLoading.value
        ? Center(
            child: SpinKitDoubleBounce(
              color: ColorsData.primary,
            ),
          )
        : Container(
            height: 250.h,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: ColorsData.cardColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.w, bottom: 14.h),
                  child: Text(
                    'salonBookingRate'.tr,
                    style: Styles.textStyleS14W600(color: Colors.white),
                  ),
                ),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _calculateMaxY(controller),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (value) {
                            return ColorsData.primary.withOpacity(0.8);
                          },
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final months = [
                              'Jan'.tr,
                              'Feb'.tr,
                              'Mar'.tr,
                              'Aug'.tr,
                              'Sep'.tr,
                              'Oct'.tr,
                              'Nov'.tr,
                              'Dec'.tr
                            ];
                            return BarTooltipItem(
                              '${months[group.x.toInt()]}: ${rod.toY.toInt()}',
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final months = [
                                'Jan'.tr,
                                'Feb'.tr,
                                'Mar'.tr,
                                'Apr'.tr,
                                'May'.tr,
                                'Jun'.tr,
                                'Jul'.tr,
                                'Aug'.tr,
                                'Sep'.tr,
                                'Oct'.tr,
                                'Nov'.tr,
                                'Dec'.tr,
                              ];
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  months[value.toInt()],
                                  style: Styles.textStyleS10W400(
                                      color: Colors.white),
                                ),
                              );
                            },
                            reservedSize: 30,
                          ),
                        ),
                        // Hide left titles
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        // Show right titles
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: Styles.textStyleS10W400(
                                  color: Colors.white,
                                ).copyWith(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.right,
                              );
                            },
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: const FlGridData(show: false),
                      barGroups: _createBarGroups(controller),
                    ),
                  ),
                ),
              ],
            ),
          ));
  }

  double _calculateMaxY(StatisticsController controller) {
    int maxValue = controller.monthlyStats.value.maxBookings;

    double paddedMax = maxValue * 1.2;

    return paddedMax > 10 ? paddedMax : 10;
  }

  List<BarChartGroupData> _createBarGroups(StatisticsController controller) {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < 12; i++) {
      int bookings = controller.monthlyStats.value.getBookingsByMonthIndex(i);

      double barValue = bookings > 0 ? bookings.toDouble() : 1;

      groups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: barValue,
            color: bookings > 0
                ? ColorsData.primary.withOpacity(0.8)
                : ColorsData.primary.withOpacity(0.3),
            width: 8.w,
            borderRadius: BorderRadius.circular(5.r),
          ),
        ],
      ));
    }

    return groups;
  }
}
