import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart' as appointment;
import 'package:q_cut/modules/customer/history_feature/model/customer_history_appointment.dart';

class CustomHistoryDelete extends StatelessWidget {
  final VoidCallback onDelete;

  const CustomHistoryDelete(
      {super.key,
      required this.onDelete,
      CustomerHistoryAppointment? appointment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, left: 17.w, right: 17.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 126.w,
                height: 194.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                  ),
                  child: Image.asset(
                    AssetsData.myAppointmentImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 4.w, bottom: 4.h, top: 4.h),
                  child: Container(
                    width: double.infinity,
                    height: 194.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                      color: ColorsData.cardColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Barber shop",
                                style: Styles.textStyleS12W700(),
                              ),
                              const Spacer(),
                              Text(
                                "Cash",
                                style: Styles.textStyleS10W400(
                                    color: ColorsData.primary),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              SvgPicture.asset(
                                AssetsData.mapPinIcon,
                                width: 12.w,
                                height: 12.h,
                                colorFilter: const ColorFilter.mode(
                                  ColorsData.primary,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Text(
                                '208 , New Gaza, New Gaza',
                                style: Styles.textStyleS12W400(),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          _buildInfoRow("Service", "Hair style"),
                          _buildInfoRow("Price", "\$ 20"),
                          _buildInfoRow("Qty", "1 consumer"),
                          _buildInfoRow("Booking day", "Sat 12/1/2024"),
                          _buildInfoRow("Booking time", "11-12 pm"),
                          _buildInfoRow("Type", "booking"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          appointment.CustomBigButton(
            textData: "Delete",
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Text(
            label,
            style: Styles.textStyleS10W400(),
          ),
          const Spacer(),
          Text(
            value,
            style: Styles.textStyleS10W400(),
          ),
        ],
      ),
    );
  }
}
