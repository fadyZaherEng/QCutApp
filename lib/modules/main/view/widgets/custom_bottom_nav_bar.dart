import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/shared_pref/pref_keys.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';

class CustomBottomNavBar extends StatefulWidget {
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
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    widget.onPageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 86.h,
      decoration: BoxDecoration(
        color: ColorsData.secondary,
        border: const Border(
          top: BorderSide(color: Color(0xFFAAAAAA), width: 1),
        ),
      ),
      padding: EdgeInsets.only(top: 8.h, right: 0.w, bottom: 20.h, left: 0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: SharedPref().getBool(PrefKeys.userRole) == false
            ? [
                Expanded(
                    child: _buildNavItem(
                        AssetsData.calendarIcon, 'appointments'.tr, 0)),
                Expanded(
                    child: _buildNavItem(
                        AssetsData.bstaticsIcon, 'reports'.tr, 1)),
                Expanded(
                    child:
                        _buildNavItem(AssetsData.profileIcon, 'profile'.tr, 2)),
              ]
            : [
                Expanded(
                    child: _buildNavItem(AssetsData.homeIcon, 'home'.tr, 0)),
                Expanded(
                    child: _buildNavItem(
                        AssetsData.calendarIcon, 'appointments'.tr, 1)),
                Expanded(
                    child:
                        _buildNavItem(AssetsData.profileIcon, 'profile'.tr, 2)),
              ],
      ),
    );
  }

  Widget _buildNavItem(String assetPath, String label, int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
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
              fontSize: 13.sp,
              fontFamily: 'Alexandria',
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
