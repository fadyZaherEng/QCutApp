import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/customer/features/home_features/city_selection/models/city_model.dart';

class CityController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  final RxList<City> cities = <City>[].obs;
  final RxList<City> filteredCities = <City>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt totalBarbers = 0.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;

  // ✅ multi selection
  final RxSet<City> selectedCities = <City>{}.obs;

  bool isCitySelected(City city) {
    return selectedCities.any((c) => c.name == city.name);
  }

  void toggleCitySelection(City city) {
    if (isCitySelected(city)) {
      selectedCities.removeWhere((c) => c.name == city.name);
    } else {
      selectedCities.add(city);
    }
    selectedCities.refresh();
  }

  String getSelectedCitiesAsString() {
    return selectedCities.map((c) => c.name.trim()).join(', ');
  }

  @override
  void onInit() {
    super.onInit();
    fetchCities();
  }

  Future<void> fetchCities() async {
    try {
      isLoading.value = true;
      isError.value = false;
      errorMessage.value = '';

      final response = await _apiCall.getData(
        '${Variables.baseUrl}mainDashboard/countBarber/byCity?page=${currentPage.value}',
      );

      final responseBody = json.decode(response.body);
      print(responseBody);

      if (response.statusCode == 200) {
        final cityResponse = CityResponse.fromJson(responseBody);
        cities.assignAll(cityResponse.cities);
        filterCities(searchQuery.value);
        totalBarbers.value = cityResponse.totalBarbers;
        totalPages.value = cityResponse.pagination.totalPages;
      } else {
        isError.value = true;
        errorMessage.value =
            responseBody['message'] ?? 'Failed to fetch cities';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Network error: $e';
      Get.snackbar(
        'Error',
        'Failed to connect to server',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadMore() async {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      await fetchCities();
    }
  }

  @override
  void refresh() {
    currentPage.value = 1;
    fetchCities();
  }

  void searchCities(String query) {
    searchQuery.value = query;
    filterCities(query);
  }

  void filterCities(String query) {
    if (query.isEmpty) {
      filteredCities.assignAll(cities);
    } else {
      filteredCities.assignAll(cities
          .where(
              (city) => city.name.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  // ✅ multi-selection methods
  // void toggleCitySelection(City city) {
  //   if (selectedCityIds.contains(city.id)) {
  //     selectedCityIds.remove(city.id);
  //   } else {
  //     selectedCityIds.add(city.id);
  //   }
  // }
  //
  // bool isCitySelected(City city) => selectedCityIds.contains(city.id);

  List<City> getSelectedCitiesAsList() {
    return selectedCities.toList();
  }

  void clearSelection() {
    selectedCities.clear();
  }

  void clearSelections() {
    selectedCities.clear();
  }

  @override
  void onClose() {
    searchQuery.close();
    selectedCities.close();
    // tempSelectedCities.close();
    super.onClose();
  }
}
