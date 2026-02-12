import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/splash/logic/splash_controller.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'dart:math' as math;

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      body: Stack(
        children: [
          // 1. Deep Radial Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Color(0xFF4A485F), // Lighter center
                  ColorsData.secondary, // Deep dark edges
                ],
              ),
            ),
          ),

          // 2. Animated Floating Particles
          AnimatedBuilder(
            animation: controller.backgroundController,
            builder: (context, child) {
              return Stack(
                children: List.generate(15, (index) {
                  final random = math.Random(index);
                  final size = 4.0 + random.nextDouble() * 8.0;
                  final speed = 0.5 + random.nextDouble();
                  final opacity = 0.1 + random.nextDouble() * 0.3;
                  
                  // Calculate movement
                  double time = controller.backgroundController.value * speed;
                  double x = (math.sin(time + index) * 0.4 + 0.5) * 1.w;
                  double y = (math.cos(time * 0.8 + index) * 0.4 + 0.5) * 1.h;

                  return Positioned(
                    left: (random.nextDouble() * 1.sw) + (math.sin(time) * 30),
                    top: (random.nextDouble() * 1.sh) + (math.cos(time) * 30),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorsData.primary.withOpacity(opacity),
                        boxShadow: [
                          BoxShadow(
                            color: ColorsData.primary.withOpacity(opacity * 0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          // 3. Main Content
          AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with Multi-Animations
                    Transform.rotate(
                      angle: controller.rotationAnimation.value,
                      child: ScaleTransition(
                        scale: controller.scaleAnimation,
                        child: FadeTransition(
                          opacity: controller.fadeAnimation,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Subtle Outer Glow
                              Container(
                                width: 140.w,
                                height: 140.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: ColorsData.primary.withOpacity(0.2),
                                      blurRadius: 40,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              SvgPicture.asset(
                                width: 150.w,
                                height: 150.h,
                                AssetsData.logo,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    
                    // Text with Slide + Fade
                    SlideTransition(
                      position: controller.slideAnimation,
                      child: FadeTransition(
                        opacity: controller.fadeAnimation,
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              width: 180.w,
                              AssetsData.qCutTextImage,
                            ),
                            SizedBox(height: 15.h),
                            // New Tagline (Translated)
                            Text(
                              "tagline".tr,
                              style: TextStyle(
                                color: ColorsData.primary,
                                fontSize: 14.sp,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w400,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                                fontFamily: 'Alexandria',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          
          // 4. Version Text at Bottom
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: controller.fadeAnimation,
              child: Text(
                "v1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorsData.primary.withOpacity(0.5),
                  fontSize: 12.sp,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
