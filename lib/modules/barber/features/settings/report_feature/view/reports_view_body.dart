import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/controller/report_controller.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/models/reports_models.dart';
import 'package:intl/intl.dart';

class ReportsViewBody extends StatelessWidget {
  const ReportsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: Obx(() {
        return RefreshIndicator(
          onRefresh: controller.refreshReports,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'allBookingAppointments'.tr,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildSummaryCards(controller),
                const SizedBox(height: 16),
                _buildSearchBar(controller),
                const SizedBox(height: 16),
                _buildReportsHeader(),
                controller.isLoading.value && controller.bills.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _buildTableContent(controller),
                controller.bills.isNotEmpty
                    ? _buildPagination(controller)
                    : const SizedBox.shrink(),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSummaryCards(ReportController controller) {
    return Row(
      children: [
        _summaryCard(
            "previousBooking".tr,
            "${controller.reportCounts.value.previousAppointments}",
            "appointment".tr),
        const SizedBox(width: 8),
        _summaryCard(
            "todayBooking".tr,
            "${controller.reportCounts.value.todayAppointments}",
            "appointment".tr),
        const SizedBox(width: 8),
        _summaryCard(
            "nextFourDays".tr,
            "${controller.reportCounts.value.upcomingAppointments}",
            "appointment".tr),
      ],
    );
  }

  Widget _summaryCard(String title, String count, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorsData.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(AssetsData.calendarIcon,
                height: 20, color: ColorsData.primary),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              count,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorsData.thirty,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ReportController controller) {
    return CustomTextFormField(
      hintText: "tapToSearchByDate".tr,
      prefixIcon: const Icon(Icons.search, color: Colors.grey),
      suffixIcon: Obx(() => controller.selectedDate.value != null
          ? IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: controller.clearSearchFilter,
            )
          : const SizedBox.shrink()),
      fillColor: Colors.white,
      controller: controller.searchController, // Use directly without .value
      readOnly: true, // Make it read-only as we're using a date picker
      onTap: () => controller.showDatePickerAndSearch(Get.context!),
    );
  }

  Widget _buildReportsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(AssetsData.calendarIcon,
                height: 16, color: ColorsData.primary),
            const SizedBox(width: 6),
            Text('allReports'.tr,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp)),
            const Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon:
                  const Icon(Icons.download, color: ColorsData.font, size: 16),
              label: Text('download'.tr,
                  style: TextStyle(color: ColorsData.font, fontSize: 12.sp)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GetX<ReportController>(
          builder: (controller) {
            final dateText = controller.selectedDate.value != null
                ? '${'showingReportsFor'.tr} ${DateFormat('MM/dd/yyyy').format(controller.selectedDate.value!)}'
                : 'hereYouCanSeeAllYourBookingReports'.tr;
            return Text(
              dateText,
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            );
          },
        ),
        const SizedBox(height: 16),
        _buildTableHeader(),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: ColorsData.cardColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _tableHeaderCell('name'.tr, flex: 2),
          _tableHeaderCell('date'.tr, flex: 2),
          _tableHeaderCell('services'.tr, flex: 2),
          _tableHeaderCell('price'.tr,flex: 2),
          _tableHeaderCell('qcutTax'.tr, flex: 2),
          _tableHeaderCell('total'.tr, flex: 2),
        ],
      ),
    );
  }

  Widget _tableHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(text,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 9.sp)),
      ),
    );
  }

  Widget _buildTableContent(ReportController controller) {
    if (controller.bills.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text('noReportsFound'.tr,
              style: TextStyle(color: Colors.white, fontSize: 14.sp)),
        ),
      );
    }

    return Column(
      children: controller.bills.map((bill) {
        return _billRow(bill);
      }).toList(),
    );
  }

  Widget _billRow(Bill bill) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _tableCell(bill.customer.fullName, flex: 2),
          _tableCell(bill.formattedDate, flex: 2),
          _tableCell('${bill.serviceCount} ${'services'.tr.toLowerCase()}',
              flex: 2),
          _tableCell('\$${bill.price.toStringAsFixed(0)}'),
          _tableCell('\$${bill.taxAmount.toStringAsFixed(0)}', flex: 2),
          _tableCell('\$${bill.priceAfterTax.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _tableCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Center(
          child: Text(text,
              style: TextStyle(fontSize: 9.sp, color: Colors.black))),
    );
  }

  Widget _buildPagination(ReportController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _paginationButton(Icons.arrow_back_ios,
            onPressed: controller.currentPage.value > 1
                ? () {
                    controller.currentPage.value--;
                    controller.fetchReports();
                  }
                : null),
        ...List.generate(
          controller.totalPages.value > 5 ? 3 : controller.totalPages.value,
          (index) => _pageNumber(
            "${index + 1}",
            isSelected: index + 1 == controller.currentPage.value,
            onTap: () {
              controller.currentPage.value = index + 1;
              controller.fetchReports();
            },
          ),
        ),
        if (controller.totalPages.value > 3)
          const Text("...", style: TextStyle(color: Colors.white)),
        if (controller.totalPages.value > 3)
          _pageNumber(
            "${controller.totalPages.value}",
            isSelected:
                controller.totalPages.value == controller.currentPage.value,
            onTap: () {
              controller.currentPage.value = controller.totalPages.value;
              controller.fetchReports();
            },
          ),
        _paginationButton(Icons.arrow_forward_ios,
            onPressed:
                controller.currentPage.value < controller.totalPages.value
                    ? () {
                        controller.currentPage.value++;
                        controller.fetchReports();
                      }
                    : null),
      ],
    );
  }

  Widget _paginationButton(IconData icon, {Function()? onPressed}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon,
          color: onPressed != null ? ColorsData.primary : Colors.grey,
          size: 16),
    );
  }

  Widget _pageNumber(String number,
      {bool isSelected = false, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ColorsData.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          number,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
