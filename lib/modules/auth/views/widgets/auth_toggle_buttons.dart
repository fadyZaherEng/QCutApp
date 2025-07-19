


// import 'package:flutter/material.dart';

// class AuthToggleButtons extends StatefulWidget {
//   final Function(int) onSelected;

//   const AuthToggleButtons({super.key, required this.onSelected});

//   @override
//   _AuthToggleButtonsState createState() => _AuthToggleButtonsState();
// }

// class _AuthToggleButtonsState extends State<AuthToggleButtons> {
//   int selectedIndex = 0; // افتراضيًا "Log in" مفعّل

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 220, // عرض الأزرار بالكامل
//       height: 40, // ارتفاع الأزرار
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           _buildButton(title: "Log in", index: 0),
//           _buildButton(title: "Sign up", index: 1),
//         ],
//       ),
//     );
//   }

//   Widget _buildButton({required String title, required int index}) {
//     bool isSelected = index == selectedIndex;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedIndex = index;
//           });
//           widget.onSelected(index);
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             color: isSelected ? const Color(0xFF403C58) : Colors.white,
//             borderRadius: BorderRadius.horizontal(
//               left: Radius.circular(index == 0 ? 20 : 0),
//               right: Radius.circular(index == 1 ? 20 : 0),
//             ),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: isSelected ? Colors.amber : Colors.grey,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
