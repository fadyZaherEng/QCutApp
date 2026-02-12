import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/constants.dart';
import 'package:q_cut/core/utils/navigation_helper.dart';

class SplashController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> rotationAnimation;
  late AnimationController backgroundController;

  @override
  void onInit() {
    super.onInit();
    _initBackgroundAnimation();
    _initAnimation();
    _configureSystemUI(true);
    _navigateAfterDelay();
  }

  void _initBackgroundAnimation() {
    backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void onClose() {
    _configureSystemUI(false);
    animationController.dispose();
    backgroundController.dispose();
    super.onClose();
  }

  void _initAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutBack),
    ));

    rotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    animationController.forward();
  }

  void _configureSystemUI(bool immersive) {
    if (immersive) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(milliseconds: 3500), () {
      NavigationHelper.navigateToAndRemoveUntil(AppRouter.selectServicesPath);
    });
  }
}
