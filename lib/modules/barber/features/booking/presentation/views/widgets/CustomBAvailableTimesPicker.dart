import 'package:flutter/material.dart';

class CustomBAvailableTimesPicker extends StatelessWidget {
  final String? selectedTime;
  final Function(String) onTimeSelected;

  const CustomBAvailableTimesPicker({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  final List<String> availableTimes = const [
    "3 to 4 Pm",
    "4 to 5 Pm",
    "5 to 6 Pm",
    "6 to 7 Pm",
    "6 to 7 Pm",
    "8 to 9 Pm"
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.access_time, color: Colors.white70),
            SizedBox(width: 8),
            Text(
              "Available time",
              style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // كل صف يحتوي على 3 عناصر
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.5, // تعديل نسبة العرض إلى الارتفاع
          ),
          itemCount: availableTimes.length,
          itemBuilder: (context, index) {
            String time = availableTimes[index];
            bool isSelected = time == selectedTime;
            return GestureDetector(
              onTap: () => onTimeSelected(time),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFD4A656) : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
