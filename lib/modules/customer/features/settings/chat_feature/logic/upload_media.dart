import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';

class UploadMedia extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();


  Future<String?> uploadFile(File file, String type) async {
    try {
      final presignedResponse = await _apiCall.getPresignedUrl(type, 1);

      if (presignedResponse.statusCode == 200) {
        final jsonData = json.decode(presignedResponse.body);
        final presignedURL = jsonData["data"][0]["presignedURL"];
        final mediaURL = jsonData["data"][0]["mediaUrl"];

        final fileBytes = await file.readAsBytes();
        final uploadResponse = await _apiCall.uploadFileToPresignedUrl(
          presignedURL,
          fileBytes,
          'image/jpeg',
        );

        if (uploadResponse.statusCode == 200) {
          return mediaURL;
        }
      }
      return null;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
}
