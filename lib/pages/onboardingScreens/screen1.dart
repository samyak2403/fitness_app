import 'package:fitness_app/pages/onboardingScreens/screen2.dart';
import 'package:fitness_app/pages/onboardingScreens/screen4.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/buttonWithIcon.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:fitness_app/widgets/textButton.dart';
import 'package:fitness_app/widgets/textsRichforOnboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TxtButton(
            txt: 'Skip',
            onClick: () => changeScreen(context, const OnboardingScreen4(),
                PageTransitionType.rightToLeftWithFade, 300),
            txtClr: ColorTemplates.textClr,
            fontWt: FontWeight.w500,
            fontSz: 18.sp,
            ikon: Icons.arrow_forward_ios_rounded,
            iconSz: 15.sp,
            iconClr: ColorTemplates.textClr,
            mainaxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(
            width: 20.w,
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextRich(
                  txt1: 'BodyFit.',
                  txtClr1: ColorTemplates.textClr,
                  fontWt1: FontWeight.bold,
                  fontSZ1: 25.sp,
                  txt2: 'io',
                  txtClr2: ColorTemplates.buttonClr,
                  fontWt2: FontWeight.bold,
                  fontSZ2: 25.sp,
                ),
                SizedBox(
                  height: 30.h,
                ),
                SizedBox(
                  height: 300.h,
                  width: 300.w,
                  child: LottieBuilder.asset(
                    'assets/lotties/onboarding1.json',
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextRich(
                  txt1: '"  ',
                  txtClr1: ColorTemplates.buttonClr,
                  fontWt1: FontWeight.bold,
                  fontSZ1: 18.sp,
                  txt2:
                      'Welcome to better health! Physical and mental  well-being help you live energetically and reduce disease risk.',
                  txtClr2: ColorTemplates.textClr,
                  fontWt2: FontWeight.bold,
                  fontSZ2: 18.sp,
                  txt3: '  "',
                  txtClr3: ColorTemplates.buttonClr,
                  fontWt3: FontWeight.bold,
                  fontSZ3: 18.sp,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedIconBttn(
                      onClick: () => changeScreen(
                          context,
                          const OnboardingScreen2(),
                          PageTransitionType.rightToLeftWithFade,
                          300),
                      maxWidth: 100.w,
                      maxHeigth: 35.h,
                      bgClr: ColorTemplates.buttonClr,
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
