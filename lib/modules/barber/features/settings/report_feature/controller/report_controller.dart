import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/models/reports_models.dart';

class ReportController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  // Reports data
  final Rx<ReportCounts> reportCounts = ReportCounts.empty().obs;
  final Rx<BillsResponse> billsResponse = BillsResponse.empty().obs;
  final RxList<Bill> bills = <Bill>[].obs;

  // Pagination parameters
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;

  // UI States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMoreBills = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  // Search control
  final RxString searchQuery = ''.obs;

  // Use a plain TextEditingController instead of a Rx<TextEditingController>
  final TextEditingController searchController = TextEditingController();

  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchReportCounts();
    fetchReports();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Fetch report counts from API
  Future<void> fetchReportCounts() async {
    try {
      final response = await _apiCall.getData(Variables.COUNT_REPORTS);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        reportCounts.value = ReportCounts.fromJson(responseBody);
      } else {
        _handleApiError(response);
      }
    } catch (e) {
      _handleException(e);
    }
  }

  // Fetch reports from API with pagination
  Future<void> fetchReports({bool loadMore = false}) async {
    if (loadMore) {
      isLoadingMoreBills.value = true;
    } else {
      isLoading.value = true;
    }

    isError.value = false;
    errorMessage.value = '';

    try {
      String url = '${Variables.REPORT}?page=${currentPage.value}&limit=$limit';

      final response = await _apiCall.getData(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final newBillsResponse = BillsResponse.fromJson(responseBody);

        if (loadMore) {
          // Append new bills
          bills.addAll(newBillsResponse.bills);
        } else {
          // Replace existing bills
          bills.value = newBillsResponse.bills;
        }

        billsResponse.value = newBillsResponse;
        totalPages.value = newBillsResponse.totalPages;
      } else {
        _handleApiError(response);
      }
    } catch (e) {
      _handleException(e);
    } finally {
      isLoading.value = false;
      isLoadingMoreBills.value = false;
    }
  }

  // Search reports by date
  Future<void> searchReportsByDate(DateTime date) async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      // Format date as MM/DD/YYYY
      final formattedDate = DateFormat('MM/dd/yyyy').format(date);
      final url = '${Variables.REPORT}/search?date=$formattedDate';

      // Update search field text safely without triggering listeners
      searchController.text = formattedDate;
      selectedDate.value = date;

      final response = await _apiCall.getData(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final newBillsResponse = BillsResponse.fromJson(responseBody);

        bills.value = newBillsResponse.bills;
        billsResponse.value = newBillsResponse;
        totalPages.value = newBillsResponse.totalPages;
        currentPage.value = 1;
      } else {
        _handleApiError(response);
      }
    } catch (e) {
      _handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Show date picker and search by selected date
  Future<void> showDatePickerAndSearch(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = selectedDate.value ?? now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.grey[900]!,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: Colors.grey[800],
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      await searchReportsByDate(picked);
    }
  }

  // Load more reports (pagination)
  Future<void> loadMoreReports() async {
    if (currentPage.value < totalPages.value && !isLoadingMoreBills.value) {
      currentPage.value++;
      await fetchReports(loadMore: true);
    }
  }

  // Refresh reports
  Future<void> refreshReports() async {
    // Clear any selected date filter
    if (selectedDate.value != null) {
      selectedDate.value = null;
      searchController.clear();
    }

    currentPage.value = 1;
    await fetchReportCounts();
    await fetchReports();
  }

  // Handle API errors
  void _handleApiError(dynamic response) {
    isError.value = true;
    try {
      final responseBody = json.decode(response.body);
      errorMessage.value = responseBody['message'] ?? 'failedToFetchReports'.tr;
    } catch (e) {
      errorMessage.value = '${'error'.tr}: ${response.statusCode}';
    }
    ShowToast.showError(message: errorMessage.value);
  }

  // Handle exceptions
  void _handleException(dynamic e) {
    isError.value = true;
    errorMessage.value = '${'networkError'.tr}: $e';
    Get.snackbar('error'.tr, errorMessage.value,
        backgroundColor: Colors.red, colorText: Colors.white);
  }

  // Clear search filter
  void clearSearchFilter() {
    selectedDate.value = null;
    searchController.clear();
    currentPage.value = 1;
    fetchReports();
  }
}
