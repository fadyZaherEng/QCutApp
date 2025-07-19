// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:q_cut/core/utils/constants/assets_data.dart';
// import 'package:q_cut/core/utils/constants/colors_data.dart';
// import 'package:q_cut/core/utils/styles.dart';

// class BMessageInput extends StatelessWidget {
//   const BMessageInput({super.key, this.onSend, this.onCameraTap, this.onRecTap});
// final void Function()? onSend;
// final void Function()? onCameraTap;
// final void Function()? onRecTap;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.only(left: 7.w,right: 5.w,top: 90.h,bottom: 12.h),
//       child: Row(
//         children: [
//           Expanded(
//             child: SizedBox(height: 40.h,
//               child: TextField(style: Styles.textStyleS16W400(color: ColorsData.dark),
//                 decoration: InputDecoration(
//                  contentPadding: EdgeInsets.only(left: 31.w,right: 22.w),
                 
//                   hintText: "Enter your message",
//                   fillColor: ColorsData.font,
                  
//                   filled: true,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.r),
//                     borderSide: BorderSide.none,
                    
//                   ),
               
//                suffixIcon: InkWell(
//                 onTap: onSend,
                
//                 child: const Icon(Icons.send)),
//                suffixIconColor: ColorsData.thirty
               
//                 ),
//               ),
//             ),
//           ),
//                    SizedBox(width: 4.w,),

//          InkWell(
//           onTap:onCameraTap,
//           child: SvgPicture.asset(AssetsData.cameraIcon)),
//          SizedBox(width: 8.w,),
//          InkWell(
//           onTap: onRecTap,
//           child: SvgPicture.asset(AssetsData.microphoneIcon)),
//         ],
//       ),
//     );
//   }
// }

