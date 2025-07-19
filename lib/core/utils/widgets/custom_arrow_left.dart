import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';

class CustomArrowLeft extends StatelessWidget {
  const CustomArrowLeft({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24,
      onPressed: onPressed ?? () => Get.back(),
      icon: const Icon(
        Icons.arrow_back,
        color: ColorsData.font,
      ),
    );
  }
}
