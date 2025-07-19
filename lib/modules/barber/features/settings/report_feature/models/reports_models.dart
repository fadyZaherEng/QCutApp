import 'package:intl/intl.dart';

// Model for the report counts
class ReportCounts {
  final int todayAppointments;
  final int previousAppointments;
  final int upcomingAppointments;

  ReportCounts({
    required this.todayAppointments,
    required this.previousAppointments,
    required this.upcomingAppointments,
  });

  factory ReportCounts.fromJson(Map<String, dynamic> json) {
    return ReportCounts(
      todayAppointments: json['todayAppointments'] ?? 0,
      previousAppointments: json['previousAppointments'] ?? 0,
      upcomingAppointments: json['upcomingAppointments'] ?? 0,
    );
  }

  factory ReportCounts.empty() {
    return ReportCounts(
      todayAppointments: 0,
      previousAppointments: 0,
      upcomingAppointments: 0,
    );
  }
}

// Model for the customer in the bill
class Customer {
  final String id;
  final String fullName;

  Customer({
    required this.id,
    required this.fullName,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}

// Model for a single bill
class Bill {
  final String id;
  final double price;
  final String barber;
  final Customer customer;
  final DateTime date;
  final String paymentType;
  final double taxAmount;
  final double priceAfterTax;
  final int serviceCount;

  Bill({
    required this.id,
    required this.price,
    required this.barber,
    required this.customer,
    required this.date,
    required this.paymentType,
    required this.taxAmount,
    required this.priceAfterTax,
    required this.serviceCount,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['_id'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      barber: json['barber'] ?? '',
      customer: Customer.fromJson(json['customer'] ?? {}),
      date: DateTime.fromMillisecondsSinceEpoch(json['date'] ?? 0),
      paymentType: json['paymentType'] ?? '',
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      priceAfterTax: (json['priceAfterTax'] ?? 0).toDouble(),
      serviceCount: json['serviceCount'] ?? 0,
    );
  }

  String get formattedDate => DateFormat('MM/dd/yyyy').format(date);
}

// Model for the bill response
class BillsResponse {
  final int page;
  final int limit;
  final int totalPages;
  final int totalBills;
  final List<Bill> bills;

  BillsResponse({
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.totalBills,
    required this.bills,
  });

  factory BillsResponse.fromJson(Map<String, dynamic> json) {
    List<Bill> billsList = [];
    if (json['bills'] != null) {
      billsList = List<Bill>.from(
        (json['bills'] as List).map((x) => Bill.fromJson(x)),
      );
    }

    return BillsResponse(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
      totalBills: json['totalBills'] ?? 0,
      bills: billsList,
    );
  }

  factory BillsResponse.empty() {
    return BillsResponse(
      page: 1,
      limit: 10,
      totalPages: 1,
      totalBills: 0,
      bills: [],
    );
  }
}
