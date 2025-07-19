class GalleryResponse {
  final List<String> photos;

  GalleryResponse({required this.photos});

  factory GalleryResponse.fromJson(Map<String, dynamic> json) {
    return GalleryResponse(
      photos: List<String>.from(json['photos'] ?? []),
    );
  }
}
