import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/text.dart';

// ignore: must_be_immutable
class CalculatorReadings extends StatelessWidget {
  VoidCallback onClick;
  double bmi;
  int bmr;
  int hrc;
  CalculatorReadings({
    Key? key,
    required this.onClick,
    required this.bmi,
    required this.bmr,
    required this.hrc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      height: 250.h,
      decoration: BoxDecoration(
        border: Border.all(color: ColorTemplates.primary),
        color: ColorTemplates.textClr,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: onClick,
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    // width: 40,
                    child: LottieBuilder.asset(
                      'assets/lotties/steps.json',
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Txt(
                    txt: bmi != null ? bmi.toStringAsFixed(2) : 'N/A',
                    fontSz: 10.sp,
                    fontWt: FontWeight.bold,
                    txtClr: Colors.white,
                  ),
                  Txt(
                    txt: 'BMI',
                    fontSz: 10.sp,
                    fontWt: FontWeight.bold,
                    txtClr: Colors.white,
                  ),
                ],
              ),
            ),
            Divider(
              indent: 8.w,
              endIndent: 8.w,
              color: Colors.white,
            ),
            InkWell(
              onTap: onClick,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: LottieBuilder.asset('assets/lotties/flame.json'),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Txt(
                    txt: bmr != null ? bmr.toString() : 'N/A',
                    fontSz: 10.sp,
                    fontWt: FontWeight.bold,
                    txtClr: Colors.white,
                  ),
                  Txt(
                    txt: 'BMR',
                    fontSz: 10.sp,
                    fontWt: FontWeight.bold,
                    txtClr: Colors.white,
                  ),
                ],
              ),
            ),
            Divider(
              indent: 8.w,
              endIndent: 8.w,
              color: Colors.white,
            ),
            InkWell(
              onTap: onClick,
              child: Column(
                children: [
                  SizedBox(height: 6.h),
                  SizedBox(
                    height: 25.h,
                    width: 25.h,
                    child: LottieBuilder.asset('assets/lotties/heart1.json'),
                  ),
                  SizedBox(height: 5.h),
                  Txt(
                    txt: hrc != null ? hrc.toString() : 'N/A',
                    fontSz: 10.sp,
                    fontWt: FontWeight.bold,
                    txtClr: Colors.white,
                  ),
                  Txt(
                    txt: 'HRC',
                    fontSz: 10.sp,
                    fontWt: FontWeight.bold,
                    txtClr: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
