import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/functions/show_payment_details_bottom_sheet.dart';

class NoCardsYetBottomSheet extends StatelessWidget {
  const NoCardsYetBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Icon(Icons.close, size: 24.sp),
              ),
            ),
            SizedBox(height: 5.h),
           Image.asset(AssetsData.myCardsImage),
            SizedBox(height: 12.h),
            Text(
              "My Cards",
              style: Styles.textStyleS20W700(color: ColorsData.secondary),
            ),
            SizedBox(height: 42.h),
            Text(
              "No Cards Yet",
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            SizedBox(height: 45.h),
            CustomBigButton(
              textData: "+ Add New Card",
              onPressed: () {
                context.pop();
                showPaymentDetailsBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
