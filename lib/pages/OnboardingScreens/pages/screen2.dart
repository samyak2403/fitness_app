import 'package:fitness_app/pages/OnboardingScreens/pages/screen1.dart';
import 'package:fitness_app/pages/OnboardingScreens/pages/screen3.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/buttonWithIcon.dart';
import 'package:fitness_app/widgets/iconButton.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:fitness_app/widgets/textsRichforOnboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconBttn(
              onClick: () => changeScreen(context, const OnboardingScreen1(),
                  PageTransitionType.leftToRightWithFade, 200),
              ikon: Icons.arrow_back_ios_new_rounded,
              ikonClr: ColorTemplates.textClr,
              ikonSz: 20.w)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                      text: 'Be',
                      style: GoogleFonts.ubuntu(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp),
                      children: [
                        TextSpan(
                          text: 'Fit',
                          style: GoogleFonts.ubuntu(
                              color: const Color(0xFF01FBE2),
                              fontWeight: FontWeight.bold,
                              fontSize: 25.sp),
                        )
                      ]),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  height: 300.h,
                  width: 300.w,
                  child: LottieBuilder.asset(
                    'assets/lotties/onboarding/onboarding2.json',
                  ),
                ),
                TextRich(
                  txt1: '"  ',
                  txtClr1: const Color(0xFF01FBE2),
                  fontWt1: FontWeight.bold,
                  fontSZ1: 18.sp,
                  txt2:
                      'A balanced diet provides essential nutrients, maintains weight, boosts immunity, and prevents diseases. Make smart food choices to fuel your fitness journey.',
                  txtClr2: ColorTemplates.textClr,
                  fontWt2: FontWeight.bold,
                  fontSZ2: 18.sp,
                  txt3: '  "',
                  txtClr3: const Color(0xFF01FBE2),
                  fontWt3: FontWeight.bold,
                  fontSZ3: 18.sp,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedIconBttn(
                      onClick: () => changeScreen(
                          context,
                          const OnboardingScreen3(),
                          PageTransitionType.rightToLeftWithFade,
                          200),
                      minWidth: 100.w,
                      minHeigth: 35.h,
                      bgClr: const Color(0xFF01FBE2),
                      elevationValue: 5.w,
                      mainaxisAlignment: MainAxisAlignment.center,
                      txt: 'next',
                      fontWt: FontWeight.bold,
                      fontSz: 18.sp,
                      txtClr: ColorTemplates.textClr,
                      ikon: Icons.arrow_forward_ios_rounded,
                      iconClr: ColorTemplates.textClr,
                      iconSz: 15.w,
                      width: 0.w,
                      // isLoading: false,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
