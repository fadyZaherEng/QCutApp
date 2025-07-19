import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/functions/show_payment_details_bottom_sheet.dart';

class MyCardsBottomSheet extends StatelessWidget {
  const MyCardsBottomSheet({super.key});

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
            SizedBox(height: 24.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2, 
              
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: ColorsData.font),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
InkWell(onTap: (){

},
  child: SvgPicture.asset(height: 24.h,width: 24.w,
    AssetsData.trashIcon,
    colorFilter: const ColorFilter.mode(
      ColorsData.red, 
      BlendMode.srcIn, 
    ),
  ),
),                            SizedBox(width: 8.w),
InkWell(onTap: (){
                showPaymentDetailsBottomSheet(context);

},
  child: SvgPicture.asset(height: 24.h,width: 24.w,
    AssetsData.editIcon,
    colorFilter: const ColorFilter.mode(
      ColorsData.primary, 
      BlendMode.srcIn, 
    ),
  ),
),                           ],
                        ),
                        Text(
                          "**** **** **** 2453",
                          style: Styles.textStyleS14W700(color: ColorsData.secondary),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
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
