import 'package:intl/intl.dart';

class BarberModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String city;
  final String profilePic;
  final String userType;
  final String barberShop;

  BarberModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.city,
    required this.profilePic,
    required this.userType,
    required this.barberShop,
  });

  factory BarberModel.fromJson(Map<String, dynamic> json) {
    return BarberModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      city: json['city'] ?? '',
      profilePic: json['profilePic'] ?? '',
      userType: json['userType'] ?? '',
      barberShop: json['barberShop'] ?? '',
    );
  }
}

class MonthlyInvoiceModel {
  final String id;
  final BarberModel? barberData;
  final String barber; // Could be ID or full object
  final String deal;
  final DateTime fromDate;
  final DateTime toDate;
  final int totalBookings;
  final double totalRevenue;
  final double qcuteTax;
  final double qcuteSubscription;
  final double totalAfterDeductions;
  final int cashPayments;
  final String cashMethod;
  final DateTime createdAt;
  final DateTime updatedAt;

  MonthlyInvoiceModel({
    required this.id,
    this.barberData,
    required this.barber,
    required this.deal,
    required this.fromDate,
    required this.toDate,
    required this.totalBookings,
    required this.totalRevenue,
    required this.qcuteTax,
    required this.qcuteSubscription,
    required this.totalAfterDeductions,
    required this.cashPayments,
    required this.cashMethod,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MonthlyInvoiceModel.fromJson(Map<String, dynamic> json) {
    // Handle barber information which might be an object or just an ID
    BarberModel? barberData;
    String barberId = '';

    if (json['barber'] is Map<String, dynamic>) {
      barberData = BarberModel.fromJson(json['barber']);
      barberId = barberData.id;
    } else if (json['barber'] is String) {
      barberId = json['barber'];
    }

    return MonthlyInvoiceModel(
      id: json['_id'] ?? '',
      barberData: barberData,
      barber: barberId,
      deal: json['deal'] ?? '',
      fromDate: json['fromDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['fromDate'])
          : DateTime.now(),
      toDate: json['toDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['toDate'])
          : DateTime.now(),
      totalBookings: json['totalBookings'] ?? 0,
      totalRevenue: _parseDoubleValue(json['totalRevenue']),
      qcuteTax: _parseDoubleValue(json['qcuteTax']),
      qcuteSubscription: _parseDoubleValue(json['qcuteSubscription']),
      totalAfterDeductions: _parseDoubleValue(json['totalAfterDeductions']),
      cashPayments: json['cashPayments'] ?? 0,
      cashMethod: json['cashMethod'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Helper method to safely parse double values
  static double _parseDoubleValue(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  // Helper method to format dates in MM/dd/yyyy format
  String getFormattedDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  // Helper to get formatted join date
  String get formattedJoinDate {
    return getFormattedDate(fromDate);
  }

  // Helper to calculate months since joined
  String get joinedSince {
    final now = DateTime.now();
    final months = (now.year - fromDate.year) * 12 + now.month - fromDate.month;
    return '$months months';
  }

  // Get payment status
  bool get isPaid {
    return cashMethod.toLowerCase() == 'paid';
  }

  // Get barber name from barberData if available
  String get barberName {
    return barberData?.fullName ?? 'Unknown Barber';
  }

  // Get barber shop name
  String get salonName {
    return barberData?.barberShop ?? 'Unknown Salon';
  }
}

class MonthlyInvoiceResponse {
  final List<MonthlyInvoiceModel> invoices;

  MonthlyInvoiceResponse({required this.invoices});

  factory MonthlyInvoiceResponse.fromJson(dynamic json) {
    List<MonthlyInvoiceModel> invoicesList = [];

    if (json is List) {
      invoicesList =
          json.map((invoice) => MonthlyInvoiceModel.fromJson(invoice)).toList();
    } else if (json is Map) {
      if (json.containsKey('data')) {
        final data = json['data'];
        if (data is List) {
          invoicesList = data
              .map((invoice) => MonthlyInvoiceModel.fromJson(invoice))
              .toList();
        }
      } else {
        // Try to parse the entire JSON as a single invoice
        try {
          final invoice =
              MonthlyInvoiceModel.fromJson(Map<String, dynamic>.from(json));
          invoicesList = [invoice];
        } catch (e) {
          print('Error parsing single invoice: $e');
        }
      }
    }

    return MonthlyInvoiceResponse(invoices: invoicesList);
  }
}
