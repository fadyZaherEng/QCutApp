import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';

class HomeController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  // Form Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController searchBarberController = TextEditingController();

  // Barber data
  final RxList<Barber> nearbyBarbers = <Barber>[].obs;
  final RxList<Barber> recommendedBarbers = <Barber>[].obs;
  final RxList<Barber> searchResults = <Barber>[].obs;
  final RxInt totalBarbers = 0.obs;
  final RxInt currentPage = 1.obs;

  // Search state
  final RxBool isSearching = false.obs;

  // UI States
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  // Tab controller
  late TabController tabController;

  // Form Keys
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    // Initialize with static data first

    // Then try to fetch from API
    getBarbers();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    searchBarberController.dispose(); // Dispose search controller
    super.onClose();
  }

  // Fetch barbers data from API
  Future<void> getBarbers() async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiCall.getData(Variables.GET_BARBERS);
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        final barbersResponse = BarbersResponse.fromJson(responseBody);

        // Update total count
        totalBarbers.value = barbersResponse.totalBarbers;
        currentPage.value = barbersResponse.page;

        // Filter and assign barbers
        final allBarbers = barbersResponse.barbers;

        // For simplicity, we'll consider all barbers as nearby
        // and active barbers as recommended
        nearbyBarbers.value = allBarbers;
        recommendedBarbers.value =
            allBarbers.where((barber) => barber.status == 'active').toList();
      } else {
        isError.value = true;
        errorMessage.value =
            responseBody['message'] ?? 'Failed to fetch barbers data';
        ShowToast.showError(message: errorMessage.value);
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', 'Failed to connect to server',
          backgroundColor: Colors.red, colorText: Colors.white);

      // Keep using static data if API fails
    } finally {
      isLoading.value = false;
    }
  }

  // Search barbers by salon name
  Future<void> searchBarbers(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    await getBarberBySalonName(query);
  }

  // Fetch barbers data by salon name
  Future<void> getBarberBySalonName(String salonName) async {
    isLoading.value = true;
    isError.value = false;
    errorMessage.value = '';

    try {
      final response = await _apiCall
          .getData("${Variables.SEARCH_BARBER_NAME}?name=$salonName&page=1");
      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        // Handle the specific response format for search
        final int page = responseBody['page'] ?? 1;
        final int total = responseBody['total'] ?? 0;
        final List<dynamic> results = responseBody['results'] ?? [];

        // Convert results to Barber objects
        final List<Barber> barbers = results.map((barberJson) {
          return Barber.fromJson(barberJson);
        }).toList();

        // Update search results
        searchResults.value = barbers;
        totalBarbers.value = total;
        currentPage.value = page;
      } else {
        isError.value = true;
        errorMessage.value =
            responseBody['message'] ?? 'Failed to fetch barbers data';
        ShowToast.showError(message: errorMessage.value);
        searchResults.clear();
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', 'Failed to connect to server',
          backgroundColor: Colors.red, colorText: Colors.white);
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // Helper method to get working days as formatted string
  String getWorkingDaysAsString(Barber barber) {
    if (barber.workingDays.isEmpty) {
      return 'No working days set';
    }

    final List<String> formattedDays = barber.workingDays.map((day) {
      return '${day.day} (${day.startHour}:00 - ${day.endHour}:00)';
    }).toList();

    return formattedDays.join(', ');
  }

  // Helper method to get off days as string
  String getOffDaysAsString(Barber barber) {
    if (barber.offDay.isEmpty) {
      return 'No off days set';
    }

    return barber.offDay.join(', ');
  }
}
