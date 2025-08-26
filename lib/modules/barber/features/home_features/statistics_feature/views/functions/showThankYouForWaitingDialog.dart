import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

void showThankYouForWaitingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AssetsData.forgetPasswordImage,
              ),
              SizedBox(height: 16.h),
              Text(
                "Thanks you for waiting us",
                style: Styles.textStyleS16W600(color: ColorsData.primary),
              ),
              SizedBox(height: 4.h),
              Text(
                "Qcut offers a deal",
                style: Styles.textStyleS14W400(color: ColorsData.thirty),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ColorsData.font,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Qcut offer",
                      style: Styles.textStyleS14W700(color: ColorsData.primary),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "From 1/1/2024 - To 1/1/2024",
                      style:
                          Styles.textStyleS12W400(color: ColorsData.secondary),
                    ),
                    Divider(thickness: 1.w, color: Colors.grey[300]),
                    _buildOfferDetail(
                        "Qcut tax", "5% from any booking process"),
                    _buildOfferDetail("Qcut Subscription", "20\$"),
                    _buildOfferDetail("Free days", "3 days"),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsData.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text("Accept",
                          style: Styles.textStyleS14W600(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: ColorsData.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text("Contact US",
                          style: Styles.textStyleS14W600(
                              color: ColorsData.primary)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildOfferDetail(String title, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Styles.textStyleS14W500(color: ColorsData.thirty)),
        Text(value, style: Styles.textStyleS14W600(color: ColorsData.primary)),
      ],
    ),
  );
}
