import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/barber/features/booking/presentation/views/pay_to_qcut_feature/models/monthly_invoice_model.dart';

class PayToQcutController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  // UI States
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  // Data
  final Rx<List<MonthlyInvoiceModel>> invoices =
      Rx<List<MonthlyInvoiceModel>>([]);
  final Rx<MonthlyInvoiceModel?> currentInvoice =
      Rx<MonthlyInvoiceModel?>(null);

  // Payment status tracking for UI
  final RxList<bool> isPaidList = <bool>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInvoiceData();
  }

  // Fetch invoice data from API
  Future<void> fetchInvoiceData() async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      // Define the API URL
      print("${Variables.baseUrl}monthly-barber-Invoice");
      final response =
          await _apiCall.getData("${Variables.baseUrl}monthly-barber-Invoice");

      print("API Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Response body decoded type: ${responseBody.runtimeType}");

        final invoiceResponse = MonthlyInvoiceResponse.fromJson(responseBody);
        invoices.value = invoiceResponse.invoices;

        print("Fetched ${invoices.value.length} invoices");

        if (invoices.value.isEmpty) {
          isError.value = false;
          errorMessage.value = '';
          updatePaymentStatusList(); // Will set up default empty state
        } else {
          invoices.value.sort((a, b) => a.fromDate.compareTo(b.fromDate));
          currentInvoice.value = invoices.value.last;
          updatePaymentStatusList();
          print("Current invoice set: ${currentInvoice.value?.id}");
        }
      } else {
        isError.value = true;
        try {
          final responseBody = json.decode(response.body);
          errorMessage.value =
              responseBody['message'] ?? 'Failed to fetch invoice data';
        } catch (e) {
          errorMessage.value = 'Error: ${response.statusCode}';
        }
        print("Error message: ${errorMessage.value}");
        ShowToast.showError(message: errorMessage.value);
      }
    } catch (e) {
      print("Exception while fetching invoice data: $e");
      isError.value = true;
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Update payment status list based on actual invoice data
  void updatePaymentStatusList() {
    List<bool> statusList = [];

    if (invoices.value.isEmpty) {
      // For empty case, provide default statuses for UI
      statusList = [false, false, false];
    } else {
      // Sort invoices by date first to ensure correct order
      final sortedInvoices = List<MonthlyInvoiceModel>.from(invoices.value)
        ..sort((a, b) => b.fromDate.compareTo(a.fromDate)); // Newest first

      // Use real data if available, showing the most recent invoices first
      for (var invoice in sortedInvoices.take(3)) {
        // Mark as paid if cashMethod is "paid"
        statusList.add(invoice.isPaid);
      }

      // Fill with dummy data if we have less than 3 entries
      while (statusList.length < 3) {
        statusList.add(false);
      }
    }

    isPaidList.value = statusList;
  }

  // For UI interaction - toggle payment status (just for UI, not server state)
  void togglePaymentStatus(int index) {
    if (index >= 0 && index < isPaidList.length) {
      isPaidList[index] = !isPaidList[index];
    }
  }

  // Get join date from the earliest invoice
  String getJoinDate() {
    if (invoices.value.isEmpty) return 'Not joined yet'; // Default fallback

    // Find the earliest invoice by fromDate
    var earliestInvoice = invoices.value
        .reduce((a, b) => a.fromDate.isBefore(b.fromDate) ? a : b);

    return earliestInvoice.formattedJoinDate;
  }

  // Request payment for a specific bill
  Future<bool> requestPayment(
      {required String billId, required int dateTimestamp}) async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      final requestBody = {"bill": billId, "date": dateTimestamp};

      print("Requesting payment for bill: $billId, date: $dateTimestamp");
      final response = await _apiCall.addData(
          requestBody, "${Variables.baseUrl}request-payment");

      print("Payment request response status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.toNamed(AppRouter.successScreenPath);

        await fetchInvoiceData();

        return true;
      } else {
        isError.value = true;
        try {
          final responseBody = json.decode(response.body);
          errorMessage.value =
              responseBody['message'] ?? 'Failed to process payment request';
        } catch (e) {
          errorMessage.value = 'Error: ${response.statusCode}';
        }
        print("Error message: ${errorMessage.value}");
        ShowToast.showError(message: errorMessage.value);
        return false;
      }
    } catch (e) {
      print("Exception while requesting payment: $e");
      isError.value = true;
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get months since joined
  String getJoinedSince() {
    if (invoices.value.isEmpty) return 'Not joined yet'; // Default fallback

    // Find the earliest invoice by fromDate
    var earliestInvoice = invoices.value
        .reduce((a, b) => a.fromDate.isBefore(b.fromDate) ? a : b);

    return earliestInvoice.joinedSince;
  }

  // Get payment details for the UI
  List<Map<String, dynamic>> getPaymentTimeline() {
    if (invoices.value.isEmpty) {
      return [
        {
          'date': 'No data',
          'status': 'unpaid'.tr,
          'isPaid': false,
          'amount': 0.0,
        }
      ];
    }

    // Sort invoices from newest to oldest for UI
    final sortedInvoices = List<MonthlyInvoiceModel>.from(invoices.value)
      ..sort((a, b) => b.fromDate.compareTo(a.fromDate)); // Newest first

    // Return the most recent 3 or fewer invoices
    return sortedInvoices.take(3).map((invoice) {
      return {
        'date': DateFormat('M/d/yyyy').format(invoice.fromDate),
        'status': invoice.isPaid ? 'paid'.tr : 'unpaid'.tr,
        'isPaid': invoice.isPaid,
        'amount': invoice.qcuteSubscription,
      };
    }).toList();
  }
}
