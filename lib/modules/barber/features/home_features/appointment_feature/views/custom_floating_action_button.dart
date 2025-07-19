import 'package:flutter/material.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFloatingActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: ColorsData.primary,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(50), // تعديل الزوايا لتكون دائرية مستطيلة
      ),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
