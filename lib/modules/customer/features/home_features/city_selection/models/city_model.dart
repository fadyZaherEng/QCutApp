class City {
  final String name;
  final int barberCount;

  City({
    required this.name,
    required this.barberCount,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['_id'] ?? '',
      barberCount: json['count'] ?? 0,
    );
  }
}

class CityResponse {
  final bool success;
  final int totalBarbers;
  final List<City> cities;
  final Pagination pagination;

  CityResponse({
    required this.success,
    required this.totalBarbers,
    required this.cities,
    required this.pagination,
  });

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      success: json['success'] ?? false,
      totalBarbers: json['totalBarbers'] ?? 0,
      cities: (json['barberCounts'] as List<dynamic>?)
              ?.map((city) => City.fromJson(city))
              .toList() ?? [],
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalCities;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalCities,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalCities: json['totalCities'] ?? 0,
    );
  }
}
