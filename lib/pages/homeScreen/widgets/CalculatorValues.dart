import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorValues extends StatelessWidget {
  const CalculatorValues({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 20,
        bottom: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 8.h,
                  width: 10.w,
                  color: Colors.black87,
                ),
                Text(
                  " : BMI",
                  style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w800),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 8.h,
                  width: 10.w,
                  color: Colors.black54,
                ),
                Text(
                  " : BMR",
                  style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w800),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  height: 8.h,
                  width: 10.w,
                  color: Colors.black38,
                ),
                Text(
                  " : HRC",
                  style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w800),
                )
              ],
            )
          ],
        ));
  }
}
