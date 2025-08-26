import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/customer/features/bookingAndPayment/models/booking_payment_details_model.dart';
import 'package:q_cut/modules/customer/features/booking_features/select_appointment_time/controller/select_appointment_time_controller.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/custom_book_payment_methods_item.dart';

import '../../../../../../../core/utils/app_router.dart';
import '../../../../../../../core/utils/network/network_helper.dart';

class BookAppointmentWithPaymentMethodsViewBody
    extends GetView<SelectAppointmentTimeController> {
  const BookAppointmentWithPaymentMethodsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final payment = Get.arguments["bookingPaymentDetailsModel"]
        as BookingPaymentDetailsModel;
    final pay = Get.arguments["pay"];
    BookPaymentItemModel ff = BookPaymentItemModel(
        shopName: payment.salonName,
        bookingDay: payment.appointmentDate,
        bookingTime: payment.appointmentTime,
        price: payment.servicePrice,
        service: payment.serviceTitle);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 17.w),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomBookPaymentMethodsItem(
              model: ff,
            ),
            SizedBox(height: 24.h),
            Container(
              decoration: BoxDecoration(
                  color: ColorsData.cardColor,
                  borderRadius: BorderRadius.circular(16.r)),
              padding: EdgeInsets.only(
                  left: 20.w, right: 20.w, top: 22.h, bottom: 38.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "totalRequiredAmount".tr,
                    style: Styles.textStyleS12W700(color: ColorsData.primary),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "servicePrice".tr,
                        style: Styles.textStyleS14W400(),
                      ),
                      Text(
                        "\$ ${payment.servicePrice}",
                        style: Styles.textStyleS10W700(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "totalAmount".tr,
                        style: Styles.textStyleS14W400(),
                      ),
                      Text(
                        "\$ ${payment.servicePrice}",
                        style:
                            Styles.textStyleS10W700(color: ColorsData.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            const Divider(
              color: ColorsData.cardStrock,
            ),
            SizedBox(
              height: 16.h,
            ),
            CustomPaymentMethod(
              svgPath: AssetsData.cashIcon,
              title: "cash".tr,
              isSelected: true,
              onTap: () {
                //controller.toggleCashPayment();
              },
            ),
            SizedBox(
              height: 20,
            ),
            CustomBigButton(
              textData: "confirm".tr,
              onPressed: () async {
                // Format the pay object to match the exact required structure
                final Map<String, dynamic> formattedPayload = {
                  "barber": pay["barber"],
                  "service": pay["service"],
                  "startDate": pay["startDate"],
                  "paymentMethod": "cash" // Ensure it's a string without quotes
                };

                final NetworkAPICall apiCall = NetworkAPICall();
                final response = await apiCall.addData(
                    formattedPayload, Variables.APPOINTMENT);

                print("API Request Payload: $formattedPayload");
                print("API Response: ${response.body}");

                if (response.statusCode == 200) {
                  ShowToast.showSuccessSnackBar(
                      message: "appointmentBookedSuccessfully".tr);
                  Get.offAllNamed(AppRouter.bottomNavigationBar);
                } else {
                  ShowToast.showError(message: "failedToBookAppointment".tr);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPaymentMethod extends StatelessWidget {
  final String svgPath;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomPaymentMethod({
    super.key,
    required this.svgPath,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ColorsData.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  svgPath,
                  width: 22.w,
                  height: 16.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: TextStyle(
                    color: ColorsData.font,
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorsData.bodyFont, width: 1),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorsData.primary,
                          ),
                        ),
                      )
                    : null),
          ],
        ),
      ),
    );
  }
}
