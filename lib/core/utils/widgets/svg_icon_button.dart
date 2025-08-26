// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:q_cut/core/utils/constants/colors_data.dart';

// class SvgIconButton extends StatelessWidget {
//   final String svgPath;
//   final double? size;
//   final Color? color;
//   final VoidCallback? onPressed;

//   const SvgIconButton({
//     super.key,
//     required this.svgPath,
//     this.size = 24.0,
//     this.color = ColorsData.black3,
//     this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       borderRadius: BorderRadius.circular(8),
//       child: SvgPicture.asset(
//         svgPath,
//         width: size,
//         height: size,
//         colorFilter: ColorFilter.mode(
//           color!,
//           BlendMode.srcIn,
//         ),
//       ),
//     );
//   }
// }
