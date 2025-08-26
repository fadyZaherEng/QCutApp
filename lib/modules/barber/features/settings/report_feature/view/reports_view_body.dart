import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/shared_pref/pref_keys.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/main.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/logic/b_profile_controller.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/models/barber_profile_model.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/controller/report_controller.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/models/reports_models.dart';
import 'package:intl/intl.dart';
import 'package:q_cut/modules/customer/features/home_features/home/logic/home_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';

class ReportsViewBody extends StatefulWidget {
  ReportsViewBody({super.key});

  @override
  State<ReportsViewBody> createState() => _ReportsViewBodyState();
}

class _ReportsViewBodyState extends State<ReportsViewBody> {
  final totalEarnings = 0.0.obs;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await fetchProfileData();
    totalEarnings.value = (await getPreviousAppointments()).length.toDouble();
  }
  @override
 void didUpdateWidget(covariant ReportsViewBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchProfileData();
    totalEarnings.value = (getPreviousAppointments() as double?) ?? 0.0;
  }

  Future<void> fetchProfileData() async {
    try {
      final response = await _apiCall.getData(Variables.GET_PROFILE);
      final responseBody = json.decode(response.body);
      print(responseBody);
      if (response.statusCode == 200) {
        final profileResponse = BarberProfileResponse.fromJson(responseBody);
        // profileData.value = profileResponse.data;
        SharedPref().removePreference(PrefKeys.profilePic);
        SharedPref().removePreference(PrefKeys.coverPic);
        profileImage = profileResponse.data.profilePic;
        coverImage = profileResponse.data.coverPic;
        currentBarberId = profileResponse.data.id;
        await SharedPref()
            .setString(PrefKeys.profilePic, profileResponse.data.profilePic);
        await SharedPref()
            .setString(PrefKeys.coverPic, profileResponse.data.coverPic);
        // await SharedPref().setString(PrefKeys.fullName, profileResponse.data.fullName);
        // await SharedPref()
        //     .setString(PrefKeys.phoneNumber, profileResponse.data.phoneNumber);
        await SharedPref()
            .setString(PrefKeys.barberId, profileResponse.data.id);
      } else {}
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }
  }

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

  // Widget _buildSummaryCards(ReportController controller) {
  Widget _buildSummaryCards(ReportController controller) {
    return FutureBuilder<Barber?>(
      future: getBarberById(currentBarberId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final barber = snapshot.data;
        final isWorkingToday = barber != null && isBarberWorkingToday(barber);
        final nextDaysTitle =
            isWorkingToday ? "Next 6 days".tr : "Next 7 days".tr;

        return Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(() => PreviousAppointmentsScreen(
                        appointmentsFuture: getPreviousAppointments(),
                      ));
                },
                child: _summaryCard(
                  "previousBooking".tr,
                  "${int.parse(totalEarnings.value.toStringAsFixed(0))}",
                  "appointment".tr,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                "todayBooking".tr,
                "${controller.reportCounts.value.todayAppointments}",
                "appointment".tr,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                nextDaysTitle,
                "${controller.reportCounts.value.upcomingAppointments}",
                "appointment".tr,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<List<AppointmentPrvious>> getPreviousAppointments() async {
    try {
      final response = await _apiCall.getData(
        "${Variables.APPOINTMENT}previous-currently",
        body: {"type": "currently"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data["success"] == true) {
          final List appointmentsJson = data["appointments"];
          return appointmentsJson
              .map((e) => AppointmentPrvious.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      debugPrint("Error fetching previous appointments: $e");
    }
    return [];
  }

  Widget _summaryCard(String title, String count, String subtitle) {
    return Container(
      height: 150.h,
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
    );
  }

  final NetworkAPICall _apiCall = NetworkAPICall();

  Future<Barber?> getBarberById(String barberId) async {
    try {
      print("Fetching barber with ID: ${Variables.BARBER}$currentBarberId");
      final response = await _apiCall
          .getData("${Variables.BARBER}$currentBarberId"); // ✅ ضيف /
      if (response.statusCode == 200) {
        print("Barber response: ${response.body}");
        final data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          return Barber.fromJson(data);
        } else {
          debugPrint("Unexpected response format: $data");
        }
      } else {
        debugPrint(
            "Failed to fetch barber. Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error fetching barber: $e");
    }
    return null;
  }

  bool isBarberWorkingToday(Barber barber) {
    final today = DateTime.now().weekday; // 1=Mon .. 7=Sun
    final todayName = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ][today - 1];

    return barber.workingDays.any((day) => day.day == todayName);
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
      controller: controller.searchController,
      // Use directly without .value
      readOnly: true,
      // Make it read-only as we're using a date picker
      onTap: () => controller.showDatePickerAndSearch(Get.context!),
    );
  }

  void updateReportCounts(Barber barber, List<Appointment> allAppointments) {
    HomeController homeController = Get.find<HomeController>();

    final today = DateTime.now();
    final isWorking = homeController.isBarberWorkingToday(barber);

    final previous = homeController.countPreviousAppointments(allAppointments);
    final todayCount = homeController.countTodayAppointments(allAppointments);

    // ✅ هنا الشرط
    final upcoming = homeController.countUpcomingAppointments(
      allAppointments,
      days: isWorking ? 6 : 7,
      includeToday: false,
    );

    ReportCounts(
      previousAppointments: previous,
      todayAppointments: todayCount,
      upcomingAppointments: upcoming,
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
          _tableHeaderCell('price'.tr, flex: 2),
          // _tableHeaderCell('qcutTax'.tr, flex: 2),
          // _tableHeaderCell('total'.tr, flex: 2),
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
          // _tableCell('\$${bill.taxAmount.toStringAsFixed(0)}', flex: 2),
          // _tableCell('\$${bill.priceAfterTax.toStringAsFixed(0)}'),
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
      icon: Icon(
        icon,
        color: onPressed != null ? ColorsData.primary : Colors.grey,
        size: 16,
      ),
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

class AppointmentPrvious {
  final String id;
  final String userName;
  final String barberName;
  final String barberPic;
  final List<ServiceItem> services;
  final int price;
  final int duration;
  final String status;
  final DateTime startDate;

  AppointmentPrvious({
    required this.id,
    required this.userName,
    required this.barberName,
    required this.barberPic,
    required this.services,
    required this.price,
    required this.duration,
    required this.status,
    required this.startDate,
  });

  factory AppointmentPrvious.fromJson(Map<String, dynamic> json) {
    return AppointmentPrvious(
      id: json["_id"],
      userName: json["userName"] ?? "",
      barberName: json["barber"]["fullName"] ?? "",
      barberPic: json["barber"]["profilePic"] ?? "",
      services: (json["service"] as List)
          .map((e) => ServiceItem.fromJson(e))
          .toList(),
      price: json["price"],
      duration: json["duration"],
      status: json["status"],
      startDate: DateTime.fromMillisecondsSinceEpoch(json["startDate"]),
    );
  }
}

class ServiceItem {
  final String name;
  final int price;
  final int numberOfUsers;

  ServiceItem({
    required this.name,
    required this.price,
    required this.numberOfUsers,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      name: json["service"]["name"],
      price: json["price"],
      numberOfUsers: json["numberOfUsers"],
    );
  }
}

class PreviousAppointmentsScreen extends StatelessWidget {
  final Future<List<AppointmentPrvious>> appointmentsFuture;

  const PreviousAppointmentsScreen(
      {super.key, required this.appointmentsFuture});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("previousBooking".tr)),
      body: FutureBuilder<List<AppointmentPrvious>>(
        future: appointmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final appointments = snapshot.data ?? [];
          if (appointments.isEmpty) {
            return Center(child: Text("noAppointments".tr));
          }
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(appt.barberPic),
                  ),
                  title: Text(appt.barberName),
                  subtitle: Text(
                    "${appt.userName} • ${appt.services.map((s) => s.name).join(", ")}\n"
                    "${appt.status} • ${appt.startDate}",
                  ),
                  trailing: Text("${appt.price} \$"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
