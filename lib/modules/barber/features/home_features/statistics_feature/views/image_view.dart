import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/widgets/custom_arrow_left.dart';

class ImageView extends StatelessWidget {
  const ImageView({super.key});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: CustomArrowLeft(
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 300,
          ),
        ],
      ),
    );
  }
}
