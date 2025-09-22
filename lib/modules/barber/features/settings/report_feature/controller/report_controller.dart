import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/barber/features/settings/report_feature/models/reports_models.dart';

class ReportController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();
  Rx<DateTime?> selectedStartDate = Rx<DateTime?>(null);
  Rx<DateTime?> selectedEndDate = Rx<DateTime?>(null);

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
        print(responseBody);
        reportCounts.value = ReportCounts.fromJson(responseBody);
      } else {
        _handleApiError(response);
      }
    } catch (e) {
      _handleException(e);
    }
  }

  // ✅ جلب التقارير مع فلترة التاريخين لو موجودة
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

      // ✅ لو فيه startDate أو endDate نضيفهم في URL كـ query params
      if (selectedStartDate.value != null && selectedEndDate.value != null) {
        final start = DateFormat('yyyy-MM-dd').format(selectedStartDate.value!);
        final end = DateFormat('yyyy-MM-dd').format(selectedEndDate.value!);
        url += '&startDate=$start&endDate=$end';
      }

      final response = await _apiCall.getData(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final newBillsResponse = BillsResponse.fromJson(responseBody);

        if (loadMore) {
          bills.addAll(newBillsResponse.bills);
        } else {
          bills.value = newBillsResponse.bills;
        }

        billsResponse.value = newBillsResponse;
        totalPages.value = newBillsResponse.totalPages;
      } else {
        // _handleApiError(response);
      }
    } catch (e) {
      // _handleException(e);
    } finally {
      isLoading.value = false;
      isLoadingMoreBills.value = false;
    }
  }

  // ✅ سيرش بتاريخ واحد (لو استعملنا حقل البحث)
  Future<void> searchReportsByDate(DateTime date) async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      final formattedDate = DateFormat('dd/MM/yyyy').format(date);
      final url = '${Variables.REPORT}/search?date=$formattedDate';

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

  // ✅ إظهار DateRangePicker
  // Future<void> showDateRangePickerAndSearch(BuildContext context) async {
  //   final now = DateTime.now();
  //   final initialStart = selectedStartDate.value ?? now;
  //   final initialEnd = selectedEndDate.value ?? now;
  //
  //   final DateTimeRange? picked = await showDateRangePicker(
  //     context: context,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(now.year + 1),
  //     initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: ColorScheme.dark(
  //             primary: Theme.of(context).primaryColor,
  //             onPrimary: Colors.white,
  //             surface: Colors.grey[900]!,
  //             onSurface: Colors.white,
  //           ),
  //           dialogTheme: DialogTheme(backgroundColor: Colors.grey[800]),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (picked != null) {
  //     selectedStartDate.value = picked.start;
  //     selectedEndDate.value = picked.end;
  //     currentPage.value = 1;
  //     await fetchReports();
  //   }
  // }

  // Fetch reports from API with pagination
  // Future<void> fetchReports({bool loadMore = false}) async {
  //   if (loadMore) {
  //     isLoadingMoreBills.value = true;
  //   } else {
  //     isLoading.value = true;
  //   }
  //
  //   isError.value = false;
  //   errorMessage.value = '';
  //
  //   try {
  //     String url = '${Variables.REPORT}?page=${currentPage.value}&limit=$limit';
  //
  //     final response = await _apiCall.getData(url);
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseBody = json.decode(response.body);
  //       final newBillsResponse = BillsResponse.fromJson(responseBody);
  //
  //       if (loadMore) {
  //         // Append new bills
  //         bills.addAll(newBillsResponse.bills);
  //       } else {
  //         // Replace existing bills
  //         bills.value = newBillsResponse.bills;
  //       }
  //
  //       billsResponse.value = newBillsResponse;
  //       totalPages.value = newBillsResponse.totalPages;
  //     } else {
  //       _handleApiError(response);
  //     }
  //   } catch (e) {
  //     _handleException(e);
  //   } finally {
  //     isLoading.value = false;
  //     isLoadingMoreBills.value = false;
  //   }
  // }
  //
  // // Search reports by date
  // Future<void> searchReportsByDate(DateTime date) async {
  //   isLoading.value = true;
  //   isError.value = false;
  //   errorMessage.value = '';
  //
  //   try {
  //     // Format date as MM/DD/YYYY
  //     final formattedDate = DateFormat('dd/MM/yyyy').format(date);
  //     final url = '${Variables.REPORT}/search?date=$formattedDate';
  //
  //     // Update search field text safely without triggering listeners
  //     searchController.text = formattedDate;
  //     selectedDate.value = date;
  //
  //     final response = await _apiCall.getData(url);
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseBody = json.decode(response.body);
  //       final newBillsResponse = BillsResponse.fromJson(responseBody);
  //
  //       bills.value = newBillsResponse.bills;
  //       billsResponse.value = newBillsResponse;
  //       totalPages.value = newBillsResponse.totalPages;
  //       currentPage.value = 1;
  //     } else {
  //       _handleApiError(response);
  //     }
  //   } catch (e) {
  //     _handleException(e);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // Show date picker and search by selected date
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  Future<void> showDatePickerAndSearch(BuildContext context) async {
    final now = DateTime.now();
    DateTime tempSelectedDate = now;
    bool selectingStart = true; // first choose start

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  // Show start & end containers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            border: !selectingStart
                                ? null
                                : Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                            color: !selectingStart
                                ? ColorsData.primary
                                : Colors.white,
                          ),
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(startDate),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  !selectingStart ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(endDate),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  CalendarDatePicker(
                    initialDate: tempSelectedDate,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2999),
                    onDateChanged: (date) {
                      setState(() {
                        tempSelectedDate = date;
                        if (selectingStart) {
                          startDate = date;
                          selectedStartDate.value = startDate;
                          endDate = DateTime.now(); // reset end
                          selectingStart = false;
                        } else {
                          if (date.isBefore(startDate)) {
                            // enforce end >= start
                            endDate = startDate;
                            selectedEndDate.value = endDate;
                          } else {
                            endDate = date;
                            selectedEndDate.value = endDate;
                          }
                          Navigator.pop(context);
                          // Call API with both dates
                          fetchReports();
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              clearSearchFilter();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            ),
                            child: Text(
                              "clear".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              if (startDate != null && endDate != null) {
                                Navigator.pop(context);
                                // Call API with both dates
                                fetchReports();
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(16),
                                ),
                              ),
                            ),
                            child: Text(
                              "close".tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 62),
                ],
              ),
            );
          },
        );
      },
    );

    // if both picked, send them
    if (startDate != null && endDate != null) {
      selectedStartDate.value = startDate;
      selectedEndDate.value = endDate;
      await fetchReports();
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
