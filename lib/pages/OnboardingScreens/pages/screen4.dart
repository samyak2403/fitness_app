import 'package:fitness_app/pages/AuthScreens/pages/login.dart';
import 'package:fitness_app/pages/AuthScreens/pages/registeration.dart';
import 'package:fitness_app/pages/home.dart';
import 'package:fitness_app/pages/AuthScreens/services/services.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/buttonWithIcon.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:fitness_app/widgets/scaffoldMessenger.dart';
import 'package:fitness_app/widgets/text.dart';
import 'package:fitness_app/widgets/textsRichforOnboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class OnboardingScreen4 extends ConsumerStatefulWidget {
  const OnboardingScreen4({super.key});

  @override
  ConsumerState<OnboardingScreen4> createState() => _OnboardingScreen4State();
}

class _OnboardingScreen4State extends ConsumerState<OnboardingScreen4> {
  @override
  Widget build(BuildContext context) {
    final authSerivce = ref.watch(authServiceProvider);

    return Scaffold(
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
                child: LottieBuilder.asset(
                    'assets/lotties/onboarding/onboarding4.json')),
            Txt(
                txt: 'Hello, WelCome!',
                fontSz: 27.sp,
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
                // isLoading: false,
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
                onClick: () => changeScreen(context, SignInScreen(),
                    PageTransitionType.bottomToTop, 300)),
            SizedBox(
              height: 20.h,
            ),
            ElevatedIconBttn(
                // isLoading: false,
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
                onClick: () => changeScreen(context, const SignUpScreen(),
                    PageTransitionType.bottomToTop, 300)),
            SizedBox(
              height: 20.h,
            ),
            Divider(
              indent: 20.w,
              endIndent: 20.w,
              thickness: 2.w,
              color: ColorTemplates.textClr.withOpacity(.2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final user = await authSerivce.signInWithGoogle(context);
                    if (user != null) {
                      changeScreenRemoveUntil(context, HomeScreen(),
                          PageTransitionType.rightToLeftWithFade, 300);
                      SnackBarWidget.show(
                          context, "You are Sign-in successfully");
                    } else {
                      SnackBarWidget.show(context, "Your Sign-In failed");
                    }
                  },
                  child: Image.asset(
                    'assets/icons/google.png',
                    scale: 30.w,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/icons/linkedIn.png',
                    scale: 17.w,
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
