import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/models/customer_appointment_model.dart';

class CustomerAppointmentController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  // Appointments data
  final RxList<CustomerAppointment> appointments = <CustomerAppointment>[].obs;
  final RxList<CustomerAppointment> filteredAppointments =
      <CustomerAppointment>[].obs;

  // Selected appointment for detail view
  final Rx<CustomerAppointment?> selectedAppointment =
      Rx<CustomerAppointment?>(null);

  // Pagination parameters
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int limit = 10;

  // Filter states
   final RxString statusFilter = 'Pending'.obs; // default

  // UI States
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  // Fetch appointments from API with pagination
  Future<void> fetchAppointments({bool loadMore = false}) async {
    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
    }

    isError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiCall.getData(
          "${Variables.APPOINTMENT}?limit=$limit&page=${currentPage.value}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        CustomerAppointmentResponse appointmentsResponse;

        if (responseBody is List) {
          // Direct list in response
          appointmentsResponse =
              CustomerAppointmentResponse.fromJson({'data': responseBody});
        } else if (responseBody is Map) {
          // Object containing data property
          if (responseBody.containsKey('data')) {
            appointmentsResponse = CustomerAppointmentResponse.fromJson(
                Map<String, dynamic>.from(responseBody));
          } else {
            // Wrap the whole response in a fake data property
            appointmentsResponse =
                CustomerAppointmentResponse.fromJson({'data': responseBody});
          }
        } else {
          throw Exception('Unexpected response format');
        }

        if (loadMore) {
          appointments.addAll(appointmentsResponse.appointments);
        } else {
          appointments.value = appointmentsResponse.appointments;
        }

        applyFilters();

        // Update pagination info
        if (appointmentsResponse.appointments.length < limit) {
          totalPages.value = currentPage.value;
        } else {
          totalPages.value = currentPage.value + 1;
        }
      } else {
        isError.value = true;
        try {
          final responseBody = json.decode(response.body);
          errorMessage.value =
              responseBody['message'] ?? 'Failed to fetch appointments';
        } catch (e) {
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
    }
  }
  void applyFilters() {
    if (statusFilter.value == 'Pending') {
      filteredAppointments.value = appointments
          .where((app) => app.status.toLowerCase() == 'pending')
          .toList();
    } else if (statusFilter.value == 'Completed') {
      filteredAppointments.value = appointments
          .where((app) => app.status.toLowerCase() == 'completed')
          .toList();
    }

    //temp date
    filteredAppointments.add(
      CustomerAppointment(
        id: 'temp',
        status: 'completed',
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        price: 0.0,
        duration: 0,
        barber: BarberInfo(id: "555", fullName: "temp", userType: "barber"),
        createdAt: DateTime.now(),
        paymentMethod: 'temp',
        services: [],
        user: "Fady zaher",
        userName: "Fady zaher",
      ),
    );
  }


  // Set filter by status
  void setStatusFilter(String status) {
    statusFilter.value = status;
    applyFilters();
  }

  // Load more appointments (pagination)
  Future<void> loadMoreAppointments() async {
    if (currentPage.value < totalPages.value && !isLoadingMore.value) {
      currentPage.value++;
      await fetchAppointments(loadMore: true);
    }
  }

  // Select an appointment for detailed view
  void selectAppointment(CustomerAppointment appointment) {
    selectedAppointment.value = appointment;
  }

  // Delete appointment
  Future<bool> deleteAppointment(String appointmentId) async {
    try {
      print("${Variables.APPOINTMENT}cancel/$appointmentId");

      final response = await _apiCall
          .putData("${Variables.APPOINTMENT}cancel/$appointmentId", []);
      print(response.body);
      print("${Variables.APPOINTMENT}cancel/$appointmentId");

      if (response.statusCode == 200 || response.statusCode == 204) {
        appointments.removeWhere((element) => element.id == appointmentId);
        filteredAppointments
            .removeWhere((element) => element.id == appointmentId);

        ShowToast.showSuccessSnackBar(
            message: 'Appointment deleted successfully');
        return true;
      } else {
        final responseBody = json.decode(response.body);
        final message =
            responseBody['message'] ?? 'Failed to delete appointment';
        ShowToast.showError(message: message);
        return false;
      }
    } catch (e) {
      ShowToast.showError(message: 'Error occurred while deleting: $e');
      return false;
    }
  }

  // Add refresh method
  Future<void> refreshAppointments() async {
    currentPage.value = 1;
    totalPages.value = 1;
    appointments.clear();
    filteredAppointments.clear();
    await fetchAppointments();
  }
}
