import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/core/utils/widgets/simple_days_picker.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/simple_time_picker.dart';

class SearchForTheTimeViewBody extends StatefulWidget {
  const SearchForTheTimeViewBody({super.key});

  @override
  SearchForTheTimeViewBodyState createState() =>
      SearchForTheTimeViewBodyState();
}

class SearchForTheTimeViewBodyState extends State<SearchForTheTimeViewBody> {
  int selectedDay = 12;
  int selectedHour = 8;
  int selectedMinute = 0;
  String period = "PM";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 13.w, right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            color: ColorsData.cardStrock,
          ),
          SizedBox(height: 6.h),
          Text(
            "availableAppointments".tr,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.h),
          SimpleDaysPicker(
            selectedDay: selectedDay,
            onDaySelected: (day) {
              setState(() {
                selectedDay = day;
              });
            },
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              SvgPicture.asset(AssetsData.clockIcon),
              SizedBox(width: 5.w),
              Text("time".tr, style: Styles.textStyleS16W400()),
            ],
          ),
          SizedBox(height: 10.h),
          const SimpleTimePicker(),
          SizedBox(
            height: 38.h,
          ),
          CustomBigButton(
              textData: "confirm".tr,
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }
}
