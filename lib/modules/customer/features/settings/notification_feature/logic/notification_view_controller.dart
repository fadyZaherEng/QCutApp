import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/customer/features/settings/notification_feature/logic/notification_controller.dart';
import 'package:q_cut/modules/customer/features/settings/notification_feature/models/notification_model.dart';

class NotificationViewModel extends GetxController {
  final NotificationController _controller = Get.find<NotificationController>();

  // Observable for UI state
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  // Observable list of notifications
  final RxList<NotificationModel> displayedNotifications =
      <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in the notification controller
    ever(_controller.notifications, _updateViewModel);
    ever(_controller.isLoading, (loading) => isLoading.value = loading);
    ever(_controller.isError, (error) => isError.value = error);
    ever(_controller.errorMessage, (message) => errorMessage.value = message);

    // Initial load
    if (_controller.notifications.isNotEmpty) {
      _updateViewModel(_controller.notifications);
    }
  }

  void _updateViewModel(List<NotificationModel> notifications) {
    if (notifications.isEmpty) return;

    // Simply store all notifications for display
    displayedNotifications.clear();
    displayedNotifications.addAll(notifications);
  }

  // Utility methods
  String getFormattedAppointmentInfo(NotificationModel notification) {
    return notification.message;
  }

  String getWaitingListText(NotificationModel notification) {
    return notification.message;
  }

  String getNotificationTitle(NotificationModel notification) {
    return notification.user.fullName.isNotEmpty
        ? notification.user.fullName
        : "QCUT";
  }

  String getNotificationMessage(NotificationModel notification) {
    return notification.message;
  }

  String getProfileImage(NotificationModel notification) {
    return notification.user.profilePic.isNotEmpty
        ? notification.user.profilePic
        : "https://via.placeholder.com/150";
  }

  // Check if a notification should have action buttons
  bool hasActions(NotificationModel notification) {
    return notification.process.isNotEmpty &&
        notification.process.startsWith("Request");
  }

  // Actions
  void refreshNotifications() {
    _controller.refreshNotifications();
  }

  void handleAppointmentConfirmation(
      NotificationModel notification, bool confirmed) async {
    var response = await NetworkAPICall().editData(
      "${Variables.baseUrl}request-change-appointment-time/${confirmed ? "approve" : "reject"}/${notification.processId}/${notification.id}",
      {},
    );
    print(response.body);
    response.statusCode == 200
        ? ShowToast.showSuccessSnackBar(
            message: "Appointment ${confirmed ? 'confirmed' : 'rejected'}")
        : ShowToast.showError(message: "Failed to update notification");

    refreshNotifications();
  }
}
