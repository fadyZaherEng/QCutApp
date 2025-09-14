import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({
    super.key,
    this.onSend,
    this.onCameraTap,
    this.onRecTap,
    this.onSendMessage,
  });

  final void Function()? onSend;
  final void Function()? onCameraTap;
  final void Function()? onRecTap;
  final void Function(String)? onSendMessage;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Padding(
      padding: EdgeInsets.only(left: 7.w, right: 5.w, top: 25.h, bottom: 25.h),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40.h,
              child: TextField(
                controller: controller,
                style: Styles.textStyleS16W400(color: ColorsData.dark),
                onSubmitted: (value) {
                  if (value.isNotEmpty && onSendMessage != null) {
                    onSendMessage!(value);
                    controller.clear();
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 31.w, right: 22.w),
                  hintText: "enterYourMessage".tr,
                  fillColor: ColorsData.font,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: InkWell(
                    onTap: () {
                      if (controller.text.trim().isNotEmpty &&
                          onSendMessage != null) {
                        onSendMessage!(controller.text);
                        controller.clear();
                      }
                    },
                    child: const Icon(
                      Icons.send,
                      color: ColorsData.thirty,
                      size: 24,
                    ),
                  ),
                  suffixIconColor: ColorsData.thirty,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          InkWell(
            onTap: onCameraTap,
            child: SvgPicture.asset(
              AssetsData.cameraIcon,
              height: 24.h,
              width: 24.w,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          InkWell(
            onTap: onRecTap,
            child: SvgPicture.asset(
              AssetsData.microphoneIcon,
              height: 24.h,
              width: 24.w,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
