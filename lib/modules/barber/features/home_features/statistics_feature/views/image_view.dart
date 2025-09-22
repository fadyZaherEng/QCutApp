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
          Flexible(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              // height: 300,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
