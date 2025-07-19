import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/customer/features/settings/notification_feature/models/notification_model.dart';

class NotificationController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  // Pagination variables
  final RxInt totalNotifications = 0.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;
  final RxBool hasMoreData = true.obs;
  final RxBool isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  // Fetch notifications from API
  Future<void> getNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage.value = 1;
      notifications.clear();
    }

    if (isLoading.value) return;

    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiCall.getData(
          "${Variables.baseUrl}notification?limit=$limit&page=${currentPage.value}");
      final responseBody = json.decode(response.body);
      print(responseBody);
      if (response.statusCode == 200) {
        final notificationsResponse =
            NotificationResponse.fromJson(responseBody);

        // Update pagination info
        totalNotifications.value = notificationsResponse.totalCount;
        totalPages.value = notificationsResponse.totalPages;
        currentPage.value = notificationsResponse.currentPage;

        // Add notifications to the list
        notifications.addAll(notificationsResponse.data);

        // Check if we have more data to load
        hasMoreData.value = currentPage.value < totalPages.value;
      } else {
        isError.value = true;
        errorMessage.value =
            responseBody['message'] ?? 'Failed to fetch notifications';
        ShowToast.showError(message: errorMessage.value);
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', 'Failed to connect to server',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Load more notifications (pagination)
  Future<void> loadMoreNotifications() async {
    if (isLoadingMore.value || !hasMoreData.value) return;

    isLoadingMore.value = true;

    try {
      currentPage.value++;

      final response = await _apiCall.getData(
          "${Variables.baseUrl}notification?limit=$limit&page=${currentPage.value}");
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        final notificationsResponse =
            NotificationResponse.fromJson(responseBody);

        // Add new notifications to the list
        notifications.addAll(notificationsResponse.data);

        // Check if we have more data to load
        hasMoreData.value = currentPage.value < totalPages.value;
      } else {
        // If error occurs during loading more, revert the page increment
        currentPage.value--;
        ShowToast.showError(
            message:
                responseBody['message'] ?? 'Failed to load more notifications');
      }
    } catch (e) {
      // If error occurs during loading more, revert the page increment
      currentPage.value--;
      Get.snackbar('Error', 'Failed to load more notifications',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoadingMore.value = false;
    }
  }

  // Refresh notifications
  Future<void> refreshNotifications() async {
    return getNotifications(isRefresh: true);
  }

  // Get relative time from datetime
  String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
