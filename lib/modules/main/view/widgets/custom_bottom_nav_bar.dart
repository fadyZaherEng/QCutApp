import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/shared_pref/pref_keys.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int initialIndex;
  final ValueChanged<int> onPageChanged;
  final List<Widget> pages;

  const CustomBottomNavBar({
    super.key,
    this.initialIndex = 0,
    required this.onPageChanged,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 86.h,
      decoration: BoxDecoration(
        color: ColorsData.secondary,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFAAAAAA),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: 8.h,
        right: 16.w,
        bottom: 20.h,
        left: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: SharedPref().getBool(PrefKeys.userRole) == false
            ? [
                _buildNavItem(
                    context, AssetsData.bstaticsIcon, 'reports'.tr, 0),
                _buildNavItem(
                    context, AssetsData.calendarIcon, 'appointments'.tr, 1),
                _buildNavItem(context, AssetsData.profileIcon, 'profile'.tr, 2),
              ]
            : [
                _buildNavItem(context, AssetsData.homeIcon, 'home'.tr, 0),
                _buildNavItem(
                    context, AssetsData.calendarIcon, 'appointments'.tr, 1),
                _buildNavItem(context, AssetsData.profileIcon, 'profile'.tr, 2),
              ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, String assetPath, String label, int index) {
    final bool isSelected = initialIndex == index;

    return GestureDetector(
      onTap: () => onPageChanged(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            assetPath,
            height: 24.h,
            colorFilter: ColorFilter.mode(
              isSelected ? ColorsData.primary : ColorsData.font,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? ColorsData.primary : ColorsData.font,
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
