import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:q_cut/core/utils/network/api.dart';

class GalleryService {
  static Future<List<String>> getBarberGallery(String barberId) async {
    try {
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/gallery/$barberId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        List<String> photos = List<String>.from(data['photos']);
        return photos;
      } else {
        throw Exception('Failed to load gallery');
      }
    } catch (e) {
      throw Exception('Failed to load gallery: $e');
    }
  }
}
