import 'package:q_cut/modules/customer/features/booking_features/display_barber_services_feature/models/barber_service.dart';

class ServiceRequest {
  final String service;
  final int numberOfUsers;

  ServiceRequest({
    required this.service,
    required this.numberOfUsers,
  });

  Map<String, dynamic> toJson() {
    return {
      'service': service,
      'numberOfUsers': numberOfUsers,
    };
  }
}

class FreeTimeRequestModel {
  final String barber;
  final List<BarberServices>? barberServices;
  final List<ServiceRequest> services;
  bool onHolding;

  FreeTimeRequestModel({
    required this.barber,
    required this.services,
    this.barberServices,
    this.onHolding = false,
  });

  // Copy constructor with optional parameter to modify onHolding
  FreeTimeRequestModel copyWith({bool? onHolding}) {
    return FreeTimeRequestModel(
      barber: this.barber,
      services: this.services,
      barberServices: this.barberServices,
      onHolding: onHolding ?? this.onHolding,
    );
  }

  factory FreeTimeRequestModel.fromServices(
      String barberId, List<BarberServices> selectedServices,
      {List<int>? serviceQuantities, bool onHolding = false}) {
    return FreeTimeRequestModel(
      barber: barberId,
      barberServices: selectedServices, // Store the original barber services
      onHolding: onHolding,
      services: List.generate(
        selectedServices.length,
        (index) => ServiceRequest(
          service: selectedServices[index].id.toString(),
          numberOfUsers:
              serviceQuantities != null && index < serviceQuantities.length
                  ? serviceQuantities[index]
                  : 1,
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'barber': barber,
      'service': services.map((s) => s.toJson()).toList(),
      'onHolding': onHolding,
    };
  }
}
