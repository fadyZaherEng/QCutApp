import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SimpleTimePicker extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const SimpleTimePicker({
    super.key,
    required this.selectedDate,
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<SimpleTimePicker> createState() => _SimpleTimePickerState();
}

class _SimpleTimePickerState extends State<SimpleTimePicker> {
  late int selectedHour;
  late int selectedMinute;
  bool isToday = false;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hour;
    selectedMinute = widget.initialTime.minute;
  }

  List<int> getHours() {
    final now = DateTime.now();
    isToday = widget.selectedDate.year == now.year &&
        widget.selectedDate.month == now.month &&
        widget.selectedDate.day == now.day;

    if (isToday) {
      return List.generate(24 - now.hour, (index) => now.hour + index);
    } else {
      return List.generate(24, (index) => index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hours = getHours();
    final hourIndex = hours.indexOf(selectedHour).clamp(0, hours.length - 1);

    return Container(
      height: 182.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hours
          SizedBox(
            width: 60,
            child: ListWheelScrollView.useDelegate(
              controller: FixedExtentScrollController(initialItem: hourIndex),
              itemExtent: 40,
              perspective: 0.005,
              diameterRatio: 1.5,
              physics: const FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: hours.length,
                builder: (context, index) {
                  final hour = hours[index];
                  final isSelected = hour == selectedHour;
                  return Center(
                    child: Text(
                      hour.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 20,
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
              onSelectedItemChanged: (index) {
                setState(() => selectedHour = hours[index]);
                widget.onTimeSelected(
                  TimeOfDay(hour: selectedHour, minute: selectedMinute),
                );
              },
            ),
          ),

          const SizedBox(width: 8),

          // Minutes
          SizedBox(
            width: 60,
            child: ListWheelScrollView.useDelegate(
              controller:
              FixedExtentScrollController(initialItem: selectedMinute),
              itemExtent: 40,
              perspective: 0.005,
              diameterRatio: 1.5,
              physics: const FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 60,
                builder: (context, index) {
                  final isSelected = index == selectedMinute;
                  return Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontSize: 20,
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
              onSelectedItemChanged: (index) {
                setState(() => selectedMinute = index);
                widget.onTimeSelected(
                  TimeOfDay(hour: selectedHour, minute: selectedMinute),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
