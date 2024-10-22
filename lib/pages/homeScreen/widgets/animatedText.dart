import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:fitness_app/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedTxt extends StatelessWidget {
  const AnimatedTxt({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Row(
        children: [
          Txt(
            txt: 'Find Your',
            fontWt: FontWeight.bold,
            fontSz: 25.sp,
            txtClr: Colors.black,
          ),
          SizedBox(
            width: 5.w,
          ),
          AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText('Workouts...',
                  speed: Duration(milliseconds: 200),
                  textStyle: GoogleFonts.ubuntu(
                      color: const Color(0xFF08EBE2),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold)),
              TyperAnimatedText('Nutrition...',
                  speed: Duration(milliseconds: 200),
                  textStyle: GoogleFonts.ubuntu(
                      color: const Color(0xFF08EBE2),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold)),
              TyperAnimatedText('Calculators...',
                  speed: Duration(milliseconds: 200),
                  textStyle: GoogleFonts.ubuntu(
                      color: const Color(0xFF08EBE2),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold)),
              TyperAnimatedText('Yoga\'s...',
                  speed: Duration(milliseconds: 200),
                  textStyle: GoogleFonts.ubuntu(
                      color: const Color(0xFF08EBE2),
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold)),
            ],
            isRepeatingAnimation: true,
            repeatForever: true,
          )
        ],
      ),
    );
  }
}
