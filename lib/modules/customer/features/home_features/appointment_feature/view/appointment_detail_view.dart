import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/show_delete_appointment_dialog.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/logic/appointment_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/models/customer_appointment_model.dart';
import 'package:intl/intl.dart';

class AppointmentDetailView extends StatelessWidget {
  final CustomerAppointment appointment;

  const AppointmentDetailView({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerAppointmentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppointmentHeader(),
            _buildAppointmentDetails(),
            _buildServiceDetails(),
            _buildStatusSection(),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomBigButton(
                textData: "Cancel Appointment",
                onPressed: appointment.status.toLowerCase() != 'cancelled'
                    ? () {
                        showDeleteAppointmentDialog(
                          context: context,
                          onYes: () async {
                            final success = await controller
                                .deleteAppointment(appointment);
                            if (success) {
                              Get.back(); // Return to appointments list
                            }
                          },
                          onNo: () {
                            Navigator.pop(context);
                          },
                        );
                      }
                    : null,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      color: ColorsData.primary.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.barber.fullName,
            style: Styles.textStyleS18W700(),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16.w, color: ColorsData.primary),
              SizedBox(width: 8.w),
              Text(
                DateFormat('EEEE, MMM d, yyyy').format(appointment.startDate),
                style: Styles.textStyleS14W400(),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.access_time, size: 16.w, color: ColorsData.primary),
              SizedBox(width: 8.w),
              Text(
                _formatTimeRange(appointment.startDate, appointment.endDate),
                style: Styles.textStyleS14W400(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetails() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Appointment Details",
            style: Styles.textStyleS16W700(),
          ),
          SizedBox(height: 16.h),
          _buildDetailRow("Appointment ID", appointment.id),
          _buildDetailRow("Barber", appointment.barber.fullName),
          _buildDetailRow("Payment Method", appointment.paymentMethod),
          _buildDetailRow(
              "Total Price", "\$${appointment.price.toStringAsFixed(0)}"),
          _buildDetailRow("Duration", "${appointment.duration} minutes"),
          _buildDetailRow("Created On",
              DateFormat('MM/dd/yyyy').format(appointment.createdAt)),
        ],
      ),
    );
  }

  Widget _buildServiceDetails() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Details",
            style: Styles.textStyleS16W700(),
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: appointment.services.length,
            itemBuilder: (context, index) {
              final service = appointment.services[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8.h),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hair Style", // Placeholder as API doesn't provide service name
                        style: Styles.textStyleS14W700(),
                      ),
                      SizedBox(height: 8.h),
                      _buildDetailRow(
                          "Price", "\$${service.price.toStringAsFixed(0)}"),
                      _buildDetailRow(
                          "Quantity", "${service.numberOfUsers} consumer(s)"),
                      _buildDetailRow("Total",
                          "\$${(service.price * service.numberOfUsers).toStringAsFixed(0)}"),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    Color statusColor;

    switch (appointment.status.toLowerCase()) {
      case 'pending':
        statusColor = Colors.blue;
        break;
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      case 'notcome':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Status",
            style: Styles.textStyleS16W700(),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: statusColor),
            ),
            child: Text(
              appointment.status,
              style: Styles.textStyleS14W700(color: statusColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: Styles.textStyleS14W400(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Styles.textStyleS14W400(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    return "${DateFormat('h:mm a').format(start)} - ${DateFormat('h:mm a').format(end)}";
  }
}
