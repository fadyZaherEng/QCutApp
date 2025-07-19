import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/barber/features/settings/history_feature/model/barber_history_model.dart';

class HistoryController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  // History data
  final RxList<BarberHistory> historyItems = <BarberHistory>[].obs;
  final RxList<BarberHistory> filteredHistoryItems = <BarberHistory>[].obs;

  // Pagination parameters
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;

  // UI States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  // Total appointments count
  final RxInt totalHistoryCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    print("HistoryController: onInit called");
    fetchHistory();
  }

  // Fetch history from API
  Future<void> fetchHistory({bool loadMore = false}) async {
    print("fetchHistory called with loadMore: $loadMore");

    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
    }

    isError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiCall.getData(Variables.GET_BARBER_HISTORY);

      print("API Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Parse using the new model
        BarberHistoryResponse historyResponse =
            BarberHistoryResponse.fromJson(responseBody);

        print("Parsed history items: ${historyResponse.history.length}");

        if (loadMore) {
          historyItems.addAll(historyResponse.history);
        } else {
          historyItems.value = historyResponse.history;
        }

        totalHistoryCount.value = historyItems.length;
        filteredHistoryItems.value = historyItems;

        // Update pagination info if needed
        if (historyResponse.history.length < limit) {
          totalPages.value = currentPage.value;
        } else {
          totalPages.value = currentPage.value + 1;
        }
      } else {
        isError.value = true;
        try {
          final responseBody = json.decode(response.body);
          errorMessage.value =
              responseBody['message'] ?? 'failedToFetchHistory'.tr;
        } catch (e) {
          errorMessage.value = '${'error'.tr}: ${response.statusCode}';
        }
        ShowToast.showError(message: errorMessage.value);
      }
    } catch (e) {
      print("Exception while fetching history: $e");
      isError.value = true;
      errorMessage.value = '${'networkError'.tr}: $e';
      Get.snackbar('error'.tr, errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load more history items (pagination)
  Future<void> loadMoreHistory() async {
    if (currentPage.value < totalPages.value && !isLoadingMore.value) {
      currentPage.value++;
      await fetchHistory(loadMore: true);
    }
  }

  // Get status color
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'notcome':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  // Refresh history
  Future<void> refreshHistory() async {
    currentPage.value = 1;
    await fetchHistory();
  }
}
