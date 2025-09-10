import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/models/customer_appointment_model.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/models/customer_appointment_model.dart';

class CustomerAppointmentController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  // Data
  final RxList<CustomerAppointment> appointments = <CustomerAppointment>[].obs;
  final RxList<CustomerAppointment> filteredAppointments =
      <CustomerAppointment>[].obs;

  final Rx<CustomerAppointment?> selectedAppointment =
  Rx<CustomerAppointment?>(null);

  // Pagination
  final int limit = 10;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final RxBool isFetching = false.obs;

  // Filters
  final RxString statusFilter = 'pending'.obs;

  // UI state
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  /// Fetch Appointments with pagination
  Future<void> fetchAppointments({bool loadMore = false}) async {
    if (isFetching.value) return;

    isFetching.value = true;
    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
    }

    try {
      final response = await _apiCall.getData(
        "${Variables.APPOINTMENT}?limit=$limit&page=${currentPage.value}",
      );

      print("API URL: ${Variables.APPOINTMENT}?limit=$limit&page=${currentPage.value}");
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        List<dynamic> data;
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map && decoded.containsKey("data")) {
          data = decoded["data"];
        } else {
          throw Exception("Unexpected response format");
        }

        final newAppointments = data
            .map((e) => CustomerAppointment.fromJson(e))
            .toList();

        if (loadMore) {
          appointments.addAll(newAppointments);
        } else {
          appointments.value = newAppointments;
        }

        applyFilters();

        // Pagination control
        if (newAppointments.length < limit) {
          hasMore.value = false;
        } else {
          hasMore.value = true;
          currentPage.value++;
        }
      } else {
        isError.value = true;
        try {
          final responseBody = json.decode(response.body);
          errorMessage.value =
              responseBody['message'] ?? 'Failed to fetch appointments';
        } catch (_) {
          errorMessage.value = 'Error: ${response.statusCode}';
        }
        ShowToast.showError(message: errorMessage.value);
      }
    } catch (e) {
      print("Exception while fetching appointments: $e");
      isError.value = true;
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', errorMessage.value,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      isFetching.value = false;
    }
  }

  /// Filter by status
  void applyFilters() {
    if (statusFilter.value.toLowerCase() == 'all') {
      filteredAppointments.value = appointments;
    } else {
      filteredAppointments.value = appointments
          .where((a) => a.status.toLowerCase() == statusFilter.value.toLowerCase())
          .toList();
    }
  }

  void setStatusFilter(String status) {
    statusFilter.value = status;
    applyFilters();
  }

  /// Load more
  Future<void> loadMoreAppointments() async {
    if (hasMore.value && !isLoadingMore.value) {
      await fetchAppointments(loadMore: true);
    }
  }

  /// Refresh
  Future<void> refreshAppointments() async {
    currentPage.value = 1;
    hasMore.value = true;
    appointments.clear();
    filteredAppointments.clear();
    await fetchAppointments();
  }

  /// Delete appointment
  Future<bool> deleteAppointment(String appointmentId) async {
    try {
      final url = "${Variables.APPOINTMENT}cancel/$appointmentId";
      print("DELETE URL: $url");

      final response = await _apiCall.putData(url, []);
      print("DELETE Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        appointments.removeWhere((a) => a.id == appointmentId);
        filteredAppointments.removeWhere((a) => a.id == appointmentId);

        ShowToast.showSuccessSnackBar(
            message: 'Appointment deleted successfully');
        return true;
      } else {
        final responseBody = json.decode(response.body);
        ShowToast.showError(
            message: responseBody['message'] ?? 'Failed to delete appointment');
        return false;
      }
    } catch (e) {
      ShowToast.showError(message: 'Error occurred while deleting: $e');
      return false;
    }
  }

  /// Booking Again
  Future<bool> bookingAgainAppointment(
      CustomerAppointment customerAppointment) async {
    await deleteAppointment(customerAppointment.id);

    try {
      final response = await _apiCall.putData(Variables.APPOINTMENT, {
        "barber": customerAppointment.barber.id,
        "service": customerAppointment.services.map((e) => e.toJson()).toList(),
        "startDate": customerAppointment.startDate.millisecondsSinceEpoch,
        "paymentMethod": customerAppointment.paymentMethod,
      });

      print("BOOK AGAIN Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        ShowToast.showSuccessSnackBar(
            message: 'Appointment booked again successfully');
        return true;
      } else {
        final responseBody = json.decode(response.body);
        ShowToast.showError(
            message:
            responseBody['message'] ?? 'Failed to book again appointment');
        return false;
      }
    } catch (e) {
      ShowToast.showError(message: 'Error occurred while booking again: $e');
      return false;
    }
  }

  /// Select an appointment
  void selectAppointment(CustomerAppointment appointment) {
    selectedAppointment.value = appointment;
  }
}

// class CustomerAppointmentController extends GetxController {
//   final NetworkAPICall _apiCall = NetworkAPICall();
//
//   // Appointments data
//   final RxList<CustomerAppointment> appointments = <CustomerAppointment>[].obs;
//   final RxList<CustomerAppointment> filteredAppointments =
//       <CustomerAppointment>[].obs;
//
//   // Selected appointment for detail view
//   final Rx<CustomerAppointment?> selectedAppointment =
//       Rx<CustomerAppointment?>(null);
//
//   // Pagination parameters
//   final RxInt currentPage = 1.obs;
//   final RxInt totalPages = 1.obs;
//   final int limit = 10;
//
//   // Filter states
//   final RxString statusFilter = 'Pending'.obs; // default
//
//   // UI States
//   final RxBool isLoading = false.obs;
//   final RxBool isLoadingMore = false.obs;
//   final RxBool isError = false.obs;
//   final RxString errorMessage = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAppointments();
//   }
//
//   // Fetch appointments from API with pagination
//   Future<void> fetchAppointments({bool loadMore = false}) async {
//     if (loadMore) {
//       isLoadingMore.value = true;
//     } else {
//       isLoading.value = true;
//     }
//
//     isError.value = false;
//     errorMessage.value = '';
//
//     try {
//       final response = await _apiCall.getData(
//           "${Variables.APPOINTMENT}?limit=$limit&page=${currentPage.value}");
//       print(response.body);
//       print("${Variables.APPOINTMENT}?limit=$limit&page=${currentPage.value}");
//
//       if (response.statusCode == 200) {
//         final responseBody = json.decode(response.body);
//         print("responseBody: $responseBody");
//
//         CustomerAppointmentResponse appointmentsResponse;
//
//         if (responseBody is List) {
//           // Direct list in response
//           appointmentsResponse =
//               CustomerAppointmentResponse.fromJson({'data': responseBody});
//         } else if (responseBody is Map) {
//           // Object containing data property
//           if (responseBody.containsKey('data')) {
//             appointmentsResponse = CustomerAppointmentResponse.fromJson(
//                 Map<String, dynamic>.from(responseBody));
//           } else {
//             // Wrap the whole response in a fake data property
//             appointmentsResponse =
//                 CustomerAppointmentResponse.fromJson({'data': responseBody});
//           }
//         } else {
//           throw Exception('Unexpected response format');
//         }
//
//         if (loadMore) {
//           appointments.addAll(appointmentsResponse.appointments);
//         } else {
//           appointments.value = appointmentsResponse.appointments;
//         }
//
//         applyFilters();
//
//         // Update pagination info
//         if (appointmentsResponse.appointments.length < limit) {
//           totalPages.value = currentPage.value;
//         } else {
//           totalPages.value = currentPage.value + 1;
//         }
//       } else {
//         isError.value = true;
//         try {
//           final responseBody = json.decode(response.body);
//           errorMessage.value =
//               responseBody['message'] ?? 'Failed to fetch appointments';
//         } catch (e) {
//           errorMessage.value = 'Error: ${response.statusCode}';
//         }
//         ShowToast.showError(message: errorMessage.value);
//       }
//     } catch (e) {
//       print("Exception while fetching appointments: $e");
//       isError.value = true;
//       errorMessage.value = 'Network error: $e';
//       Get.snackbar('Error', errorMessage.value,
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//       isLoadingMore.value = false;
//     }
//   }
//
//   void applyFilters() {
//     if (statusFilter.value == 'Pending') {
//       filteredAppointments.value = appointments
//           .where((app) => app.status.toLowerCase() == 'pending')
//           .toList();
//     } else if (statusFilter.value == 'Completed') {
//       filteredAppointments.value = appointments
//           .where((app) => app.status.toLowerCase() == 'completed')
//           .toList();
//     }
//   }
//
//   // Set filter by status
//   void setStatusFilter(String status) {
//     statusFilter.value = status;
//     applyFilters();
//   }
//
//   // Load more appointments (pagination)
//   Future<void> loadMoreAppointments() async {
//     if (currentPage.value < totalPages.value && !isLoadingMore.value) {
//       currentPage.value++;
//       await fetchAppointments(loadMore: true);
//     }
//   }
//
//   // Select an appointment for detailed view
//   void selectAppointment(CustomerAppointment appointment) {
//     selectedAppointment.value = appointment;
//   }
//
//   // Delete appointment
//   Future<bool> deleteAppointment(String appointmentId) async {
//     try {
//       print("${Variables.APPOINTMENT}cancel/$appointmentId");
//
//       final response = await _apiCall
//           .putData("${Variables.APPOINTMENT}cancel/$appointmentId", []);
//       print(response.body);
//       print("${Variables.APPOINTMENT}cancel/$appointmentId");
//
//       if (response.statusCode == 200 || response.statusCode == 204) {
//         appointments.removeWhere((element) => element.id == appointmentId);
//         filteredAppointments
//             .removeWhere((element) => element.id == appointmentId);
//
//         ShowToast.showSuccessSnackBar(
//             message: 'Appointment deleted successfully');
//         return true;
//       } else {
//         final responseBody = json.decode(response.body);
//         final message =
//             responseBody['message'] ?? 'Failed to delete appointment';
//         ShowToast.showError(message: message);
//         return false;
//       }
//     } catch (e) {
//       ShowToast.showError(message: 'Error occurred while deleting: $e');
//       return false;
//     }
//   }
//
//   Future<bool> bookingAgainAppointment(
//       CustomerAppointment customerAppointment) async {
//     await deleteAppointment(customerAppointment.id);
//     appointments.removeWhere((element) => element.id == customerAppointment.id);
//     filteredAppointments
//         .removeWhere((element) => element.id == customerAppointment.id);
//
//     try {
//       print(Variables.APPOINTMENT);
//
//       final response = await _apiCall.putData(Variables.APPOINTMENT, {
//         "barber": customerAppointment.barber.id,
//         "service": customerAppointment.services.map((e) => e.toJson()).toList(),
//         "startDate": customerAppointment.startDate.millisecondsSinceEpoch,
//         "paymentMethod": customerAppointment.paymentMethod,
//       });
//       print(response.body);
//       print(Variables.APPOINTMENT);
//
//       if (response.statusCode == 200 || response.statusCode == 204) {
//         ShowToast.showSuccessSnackBar(
//             message: 'Appointment Booking Again successfully');
//         return true;
//       } else {
//         final responseBody = json.decode(response.body);
//         final message =
//             responseBody['message'] ?? 'Failed to Booking Again appointment';
//         ShowToast.showError(message: message);
//         return false;
//       }
//     } catch (e) {
//       ShowToast.showError(message: 'Error occurred while Booking Again: $e');
//       return false;
//     }
//   }
//
//   // Add refresh method
//   Future<void> refreshAppointments() async {
//     currentPage.value = 1;
//     totalPages.value = 1;
//     appointments.clear();
//     filteredAppointments.clear();
//     await fetchAppointments();
//   }
// }
