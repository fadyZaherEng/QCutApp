import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/modules/main/logic/main_controller.dart';
import 'package:q_cut/modules/main/view/widgets/custom_bottom_nav_bar.dart';

class HomeNavigationBar extends StatelessWidget {
  const HomeNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final MainController controller = Get.find<MainController>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: (index) {
            controller.currentIndex.value = index;
          },
          children: controller.pages,
        ),
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          initialIndex: controller.currentIndex.value,
          onPageChanged: (index) {
            controller.changePage(index);
          },
          pages: controller.pages,
        ),
      ),
    );
  }
}
