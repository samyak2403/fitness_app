import 'package:fitness_app/pages/AuthScreens/login.dart';
import 'package:fitness_app/pages/AuthScreens/registeration.dart';
import 'package:fitness_app/pages/onboardingScreens/screen3.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/buttonWithIcon.dart';
import 'package:fitness_app/widgets/iconButton.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:fitness_app/widgets/text.dart';
import 'package:fitness_app/widgets/textsRichforOnboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconBttn(
              onClick: () => changeScreen(context, const OnboardingScreen3(),
                  PageTransitionType.leftToRightWithFade, 300),
              ikon: Icons.arrow_back_ios_new_rounded,
              ikonClr: ColorTemplates.textClr,
              ikonSz: 20.w)),
      body: SafeArea(
          child: Center(
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
                height: 300.h,
                width: 300.w,
                child: LottieBuilder.asset('assets/lotties/new3.json')),
            Txt(
                txt: 'Hello, WelCome!',
                fontSz: 30.sp,
                fontWt: FontWeight.bold,
                txtClr: ColorTemplates.textClr),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Txt(
                  txt: 'Welcome to BodyFit.io Top PlatForm to Every people',
                  fontSz: 15.sp,
                  fontWt: FontWeight.w500,
                  txtClr: ColorTemplates.textClr),
            ),
            SizedBox(
              height: 20.h,
            ),
            ElevatedIconBttn(
                maxWidth: 300.w,
                maxHeigth: 50.h,
                elevationValue: 5.w,
                txt: 'Login',
                fontWt: FontWeight.bold,
                fontSz: 18.sp,
                ikon: Icons.email_outlined,
                bgClr: ColorTemplates.buttonClr,
                mainaxisAlignment: MainAxisAlignment.center,
                txtClr: ColorTemplates.textClr,
                iconClr: ColorTemplates.textClr,
                iconSz: 20.w,
                width: 10.w,
                onClick: () => const SignInScreen()),
            SizedBox(
              height: 20.h,
            ),
            ElevatedIconBttn(
                maxWidth: 300.w,
                maxHeigth: 50.h,
                elevationValue: 5.w,
                txt: 'Register',
                fontWt: FontWeight.bold,
                fontSz: 18.sp,
                ikon: Icons.list_alt_outlined,
                bgClr: ColorTemplates.buttonClr,
                mainaxisAlignment: MainAxisAlignment.center,
                txtClr: ColorTemplates.textClr,
                iconClr: ColorTemplates.textClr,
                iconSz: 20.w,
                width: 10.w,
                onClick: () => const SignUpScreen())
          ],
        ),
      )),
    );
  }
}
