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
import 'package:shared_preferences/shared_preferences.dart';

class SearchForTheTimeViewBody extends StatefulWidget {
  const SearchForTheTimeViewBody({super.key});

  @override
  SearchForTheTimeViewBodyState createState() =>
      SearchForTheTimeViewBodyState();
}

class SearchForTheTimeViewBodyState extends State<SearchForTheTimeViewBody> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    // _loadSavedDateTime(); // ✅ استرجاع القيم عند فتح الشاشة
  }

  Future<void> _loadSavedDateTime() async {
    final prefs = await SharedPreferences.getInstance();

    final savedDateString = prefs.getString('selected_date');
    final savedHour = prefs.getInt('selected_hour');
    final savedMinute = prefs.getInt('selected_minute');

    if (savedDateString != null && savedHour != null && savedMinute != null) {
      setState(() {
        selectedDate = DateTime.parse(savedDateString);
        selectedTime = TimeOfDay(hour: savedHour, minute: savedMinute);
      });
    }
  }

  Future<void> _saveDateTime() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('selected_date', selectedDate.toIso8601String());
    await prefs.setInt('selected_hour', selectedTime.hour);
    await prefs.setInt('selected_minute', selectedTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 13.w, right: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(color: ColorsData.cardStrock),
          SizedBox(height: 6.h),
          Text(
            "availableAppointments".tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),

          /// Days Picker
          SimpleDaysPicker(
            selectedDate: selectedDate,
            onDaySelected: (day) {
              setState(() => selectedDate = day);
              _saveDateTime(); // ✅ نحفظ بعد تغيير التاريخ
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

          /// Time Picker
          SimpleTimePicker(
            key: ValueKey(selectedDate), // عشان يعيد بناء الويجت لو اليوم اتغير
            selectedDate: selectedDate,
            initialTime: selectedTime,
            onTimeSelected: (time) {
              setState(() => selectedTime = time);
              _saveDateTime(); // ✅ نحفظ بعد تغيير الوقت
            },
          ),

          const Spacer(),

          CustomBigButton(
            textData: "confirm".tr,
            onPressed: () async {
              final selectedDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );

              await _saveDateTime(); // ✅ نحفظ قبل ما نرجع
              Navigator.pop(context, selectedDateTime);
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
