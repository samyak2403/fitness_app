// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:fitness_app/pages/Ai.dart';
// import 'package:fitness_app/pages/Calculator.dart';
// import 'package:fitness_app/pages/home.dart';
// import 'package:fitness_app/pages/sedule.dart';
// import 'package:fitness_app/pages/workout.dart';
// import 'package:fitness_app/utils/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class Bottomnavbar extends StatefulWidget {
//   const Bottomnavbar({super.key});

//   @override
//   State<Bottomnavbar> createState() => _BottomnavbarState();
// }

// class _BottomnavbarState extends State<Bottomnavbar> {
//   List pages = [
//     HomeScreen(),
//     Workout(),
//     NutritionAi(),
//     Calculator(),
//     Schedule()
//   ];

//   int current_page_index = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: CurvedNavigationBar(
//         backgroundColor: Colors.transparent,
//         buttonBackgroundColor: ColorTemplates.textClr,
//         color: ColorTemplates.textClr,
//         animationDuration: const Duration(milliseconds: 300),
//         items: <Widget>[
//           Icon(
//             Icons.home_outlined,
//             size: 26.w,
//             color: ColorTemplates.primary,
//           ),
//           Icon(
//             Icons.sports_gymnastics_outlined,
//             size: 26.w,
//             color: ColorTemplates.primary,
//           ),
//           Icon(
//             Icons.switch_access_shortcut_outlined,
//             size: 26.w,
//             color: ColorTemplates.primary,
//           ),
//           Icon(
//             Icons.calculate_outlined,
//             size: 26.w,
//             color: ColorTemplates.primary,
//           ),
//           Icon(
//             Icons.schedule_outlined,
//             size: 26.w,
//             color: ColorTemplates.primary,
//           )
//         ],
//         onTap: (index) {
//           setState(() {
//             current_page_index = index;
//           });
//         },
//       ),
//       body: pages[current_page_index],
//     );
//   }
// }
