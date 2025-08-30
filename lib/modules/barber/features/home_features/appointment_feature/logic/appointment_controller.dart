import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/models/appointment_model.dart';

class BAppointmentController extends GetxController {
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
  final String barberName = "barberShop".tr;
  final String barberServices = "hairStyleCutsFaceShaving".tr;
  final RxString barberImage = "".obs;

  @override
  void onInit() {
    super.onInit();
    print("BAppointmentController: onInit called");
    // Initialize with the current day
    selectedDay.value = DateTime.now().day;
    fetchAppointments();
  }

  // Fetch appointments from API with pagination
  Future<void> fetchAppointments({bool loadMore = false}) async {
    print("fetchAppointments called with loadMore: $loadMore");

    if (loadMore) {
      isLoadingMore.value = true;
      print("Loading more appointments, page: ${currentPage.value}");
    } else {
      isLoading.value = true;
      print("Loading initial appointments");
    }

    isError.value = false;
    errorMessage.value = '';

    try {
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final response = await _apiCall
          .getData("${Variables.GET_BARBER_APPOINTMENTS}$formattedDate");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("Response body decoded type: ${responseBody.runtimeType}");
        print("Response body content: $responseBody");

        BarberAppointmentResponse appointmentsResponse;

        if (responseBody is List) {
          // Direct list in response
          print("Response is a List, wrapping in data property");
          appointmentsResponse =
              BarberAppointmentResponse.fromJson({'data': responseBody});
        } else if (responseBody is Map) {
          // Object containing data property
          if (responseBody.containsKey('data')) {
            print("Response contains 'data' property");
            // Check if 'data' is a List or another complex type
            var data = responseBody['data'];
            if (data is List) {
              // Data is a list, proceed normally
              appointmentsResponse = BarberAppointmentResponse.fromJson(
                  Map<String, dynamic>.from(responseBody));
            } else {
              // Data is not a list, handle it differently
              print("'data' is not a List but ${data.runtimeType}");
              // Try to convert the data to a list if possible
              try {
                List<dynamic> dataAsList = [
                  data
                ]; // Wrap in a list if single item
                appointmentsResponse =
                    BarberAppointmentResponse.fromJson({'data': dataAsList});
              } catch (e) {
                print("Error converting data to list: $e");
                // Fallback to empty list
                appointmentsResponse =
                    BarberAppointmentResponse.fromJson({'data': []});
              }
            }
          } else {
            // Wrap the whole response in a fake data property
            print(
                "Response is a Map without 'data' property, wrapping entire response");
            appointmentsResponse = BarberAppointmentResponse.fromJson({
              'data': [responseBody]
            });
          }
        } else {
          throw Exception(
              'Unexpected response format: ${responseBody.runtimeType}');
        }

        print(
            "Parsed appointments count: ${appointmentsResponse.appointments.length}");

        if (loadMore) {
          appointments.addAll(appointmentsResponse.appointments);
          print(
              "Added ${appointmentsResponse.appointments.length} more appointments");
        } else {
          appointments.value = appointmentsResponse.appointments;
          print(
              "Set appointments with ${appointmentsResponse.appointments.length} items");
        }

        print("Total appointments loaded: ${appointments.length}");
        filterAppointmentsByDate(selectedDate.value);

        // Update pagination info
        if (appointmentsResponse.appointments.length < limit) {
          totalPages.value = currentPage.value;
          print("Reached last page: ${totalPages.value}");
        } else {
          totalPages.value = currentPage.value + 1;
          print("More pages available, total: ${totalPages.value}");
        }
      } else {
        isError.value = true;
        try {
          final responseBody = json.decode(response.body);
          print("Error response body: $responseBody");
          errorMessage.value =
              responseBody['message'] ?? 'Failed to fetch appointments';
        } catch (e) {
          print("Error parsing error response: $e");
          errorMessage.value = 'Error: ${response.statusCode}';
        }
        print("Error message: ${errorMessage.value}");
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
      print(
          "Loading state reset. isLoading: ${isLoading.value}, isLoadingMore: ${isLoadingMore.value}");
    }
  }

  Future<void> loadMoreAppointments() async {
    print(
        "loadMoreAppointments called. Current page: ${currentPage.value}, Total pages: ${totalPages.value}");
    if (currentPage.value < totalPages.value && !isLoadingMore.value) {
      currentPage.value++;
      print(
          "Loading more appointments, increasing page to: ${currentPage.value}");
      await fetchAppointments(loadMore: true);
    } else {
      print("Not loading more - either on last page or already loading");
    }
  }

  // Update the selected date and filter appointments
  void changeSelectedDay(int day) {
    print("changeSelectedDay called with day: $day");
    selectedDay.value = day;
    final now = DateTime.now();
    print("Current date: $now");

    // Calculate the correct date based on current month
    DateTime newDate;
    if (day < now.day && now.day > 25) {
      // Likely next month
      final nextMonth = DateTime(now.year, now.month + 1, 1);
      newDate = DateTime(nextMonth.year, nextMonth.month, day);
      print("Selected day is in next month: $newDate");
    } else {
      // Current month
      newDate = DateTime(now.year, now.month, day);
      print("Selected day is in current month: $newDate");
    }

    selectedDate.value = newDate;
    print(
        "Selected date updated to: ${DateFormat('yyyy-MM-dd').format(newDate)}");

    // Refresh appointments for the new date
    currentPage.value = 1;
    fetchAppointments();
  }

  // Filter appointments based on the selected date
  void filterAppointmentsByDate(DateTime date) {
    // Convert the selected date to start of day (midnight) for comparison
    final selectedStartOfDay = DateTime(date.year, date.month, date.day);
    final formattedSelectedDate =
        DateFormat('yyyy-MM-dd').format(selectedStartOfDay);
    print("Filtering appointments for date: $formattedSelectedDate");
    print("Total appointments before filtering: ${appointments.length}");

    filteredAppointments.value = appointments.where((appointment) {
      // Parse the appointment date string to DateTime
      DateTime? appointmentDate;
      try {
        // If your appointment has a startDate DateTime field:
        appointmentDate = DateTime(
          appointment.startDate.year,
          appointment.startDate.month,
          appointment.startDate.day,
        );
      } catch (e) {
        // If the date comes as a string, you might need to parse it
        try {
          // Try to parse from the formatted date string if available
          appointmentDate =
              DateFormat('yyyy-MM-dd').parse(appointment.formattedDate);
        } catch (e2) {
          print(
              "Error parsing date for appointment: ${appointment.id} - ${e2.toString()}");
          return false;
        }
      }

      final formattedApptDate =
          DateFormat('yyyy-MM-dd').format(appointmentDate);
      final matches = formattedApptDate == formattedSelectedDate;

      print(
          "Appointment ${appointment.id}: date=$formattedApptDate, matches=$matches");

      return matches;
    }).toList();

    print(
        "Filtered appointments: ${filteredAppointments.length} for date $formattedSelectedDate");
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

  // Refresh appointments
  Future<void> refreshAppointments() async {
    print("refreshAppointments called");
    currentPage.value = 1;
    await fetchAppointments();
  }

  // Delete appointment
  Future<bool> didntComeAppointment(String appointmentId) async {
    try {
      print("${Variables.APPOINTMENT}not-come/$appointmentId");

      final response = await _apiCall
          .putData("${Variables.APPOINTMENT}not-come/$appointmentId", []);
      print(response.body);
      print("${Variables.APPOINTMENT}not-come/$appointmentId");

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
  Future<List<String>> getTimeSlotAppointment(
      String appointmentId, String date) async {
    try {
      final url =
          "${Variables.APPOINTMENT}$appointmentId/available-times?date=$date";
      print("➡️ Request: $url");

      final response = await _apiCall.getData(url); // ✅ GET مش PUT
      print("⬅️ Response: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody['availableTimes'] != null) {
          final times = (responseBody['availableTimes'] as List)
              .map((e) => e['slot'].toString())
              .toList();

          return times; // ✅ رجع list من ال slots
        } else {
          ShowToast.showError(message: "No available times found");
          return [];
        }
      } else {
        final responseBody = json.decode(response.body);
        final message =
            responseBody['message'] ?? 'Failed to fetch available times';
        // ShowToast.showError(message: message);
        return [];
      }
    } catch (e) {
      ShowToast.showError(message: 'Error occurred: $e');
      return [];
    }
  }

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
}
