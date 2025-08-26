import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/shared_pref/pref_keys.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/models/appointment_model.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/models/statistics_model.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/models/payment_stats_model.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/models/monthly_stats_model.dart';

class StatisticsController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  // Appointments data
  final RxList<BarberAppointment> appointments = <BarberAppointment>[].obs;
  final RxList<BarberAppointment> filteredAppointments =
      <BarberAppointment>[].obs;

  // Pagination parameters
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;

  // UI States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  // Selected date for filtering
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxInt selectedDay = 0.obs;

  // Barber profile info
  final RxString barberName = "Barber shop".obs;
  final RxString barberServices = "Hair Style, Cuts, Face shaving".obs;
  final RxString barberImage = "".obs;

  // Statistics data
  final Rx<BarberStats> barberStats = BarberStats.empty().obs;
  final RxBool isStatsLoading = false.obs;
  final RxString statsTimeFrame = 'All Time'.obs; // Default time frame

  // Payment Statistics data
  final Rx<PaymentStats> paymentStats = PaymentStats.empty().obs;
  final RxBool isPaymentStatsLoading = false.obs;

  // Monthly Statistics data
  final Rx<MonthlyStats> monthlyStats = MonthlyStats.empty().obs;
  final RxBool isMonthlyStatsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with the current day
    selectedDay.value = DateTime.now().day;
    refreshAllStats();
  }

  Future<void> refreshAllStats() async {
    await Future.wait(
        [fetchBarberStats(), fetchPaymentStats(), fetchMonthlyStats()]);
  }

  Future<void> fetchBarberStats() async {
    isStatsLoading.value = true;
    final barberId = SharedPref().getString(PrefKeys.id);
    try {
      final response =
          await _apiCall.getData(Variables.BARBER_STATS + barberId!);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody is Map<String, dynamic>) {
          barberStats.value = BarberStats.fromJson(responseBody);
        } else {
          barberStats.value = BarberStats.empty();
        }
      } else {
        ShowToast.showError(message: 'Failed to load statistics');
      }
    } catch (e) {
      barberStats.value = BarberStats.empty();
      Get.snackbar('Error', 'Failed to load statistics data',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isStatsLoading.value = false;
    }
  }

  Future<void> fetchPaymentStats() async {
    isPaymentStatsLoading.value = true;

    try {
      final response = await _apiCall
          .getData("${Variables.BARBER_PAYMENT_STATS}67a0fd56178e0969cb60b765");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody is Map<String, dynamic>) {
          paymentStats.value = PaymentStats.fromJson(responseBody);
        } else {
          paymentStats.value = PaymentStats.empty();
        }
      } else {
        ShowToast.showError(message: 'Failed to load payment statistics');
      }
    } catch (e) {
      paymentStats.value = PaymentStats.empty();
      Get.snackbar('Error', 'Failed to load payment statistics data',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isPaymentStatsLoading.value = false;
    }
  }

  Future<void> fetchMounthStats() async {
    isPaymentStatsLoading.value = true;

    try {
      final response = await _apiCall
          .getData('${Variables.BARBER_COUNT_MOUNTH}67a0fd56178e0969cb60b765');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody is Map<String, dynamic>) {
          paymentStats.value = PaymentStats.fromJson(responseBody);
        } else {
          paymentStats.value = PaymentStats.empty();
        }
      } else {
        ShowToast.showError(message: 'Failed to load payment statistics');
      }
    } catch (e) {
      paymentStats.value = PaymentStats.empty();
      Get.snackbar('Error', 'Failed to load payment statistics data',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isPaymentStatsLoading.value = false;
    }
  }

  Future<void> fetchMonthlyStats() async {
    isMonthlyStatsLoading.value = true;

    try {
      final response = await _apiCall
          .getData("${Variables.BARBER_COUNT_MOUNTH}67a0fd56178e0969cb60b765");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody is List) {
          monthlyStats.value = MonthlyStats.fromJson(responseBody);
        } else {
          monthlyStats.value = MonthlyStats.empty();
        }
      } else {
        ShowToast.showError(message: 'Failed to load monthly statistics');
      }
    } catch (e) {
      monthlyStats.value = MonthlyStats.empty();
      Get.snackbar('Error', 'Failed to load monthly statistics data',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isMonthlyStatsLoading.value = false;
    }
  }

  void updateTimeFrame(String timeFrame) {
    statsTimeFrame.value = timeFrame;
    fetchBarberStats();
    fetchPaymentStats();
    fetchMonthlyStats();
  }

  int get totalConsumers =>
      barberStats.value.newConsumers + barberStats.value.returningConsumers;

  double get incomePerHour {
    if (barberStats.value.workingHours == 0) return 0;
    return barberStats.value.totalIncome / barberStats.value.workingHours;
  }

  String get formattedIncomePerHour => incomePerHour.toStringAsFixed(2);
}
