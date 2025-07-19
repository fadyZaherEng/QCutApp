import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:q_cut/core/utils/constants/api_constants.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';

class GalleryController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();
  RxList<String> photos = <String>[].obs;
  RxBool isLoading = true.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> fetchGallery(String barberId) async {
    isLoading.value = true;
    hasError.value = false;

    try {
      final response =
          await _apiCall.getData('${Variables.baseUrl}gallery/$barberId');

      print('Response status: ${response.body}');
      if (response.statusCode == 200) {
        try {
          final dynamic decodedData = json.decode(response.body);

          // Handle case when response is not a Map
          if (decodedData is! Map<String, dynamic>) {
            photos.value = [];
            return;
          }

          final Map<String, dynamic> data = decodedData;

          // Handle both empty object {} and regular response with photos array
          if (data.isEmpty || data['photos'] == null) {
            photos.value = [];
          } else {
            List<String> photosList = List<String>.from(data['photos'] ?? []);
            photos.value = photosList;
          }
        } on FormatException catch (e) {
          // Handle JSON format issues
          photos.value = [];
          hasError.value = true;
          errorMessage.value = 'Invalid response format';
          print('Error parsing gallery response: $e');
        }
      } else {
        hasError.value = true;
        errorMessage.value = 'Failed to load gallery';
      }
    } catch (e) {
      hasError.value = true;
      photos.value = []; // Ensure empty list on error
      errorMessage.value = e.toString();
      print('Error fetching gallery: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
