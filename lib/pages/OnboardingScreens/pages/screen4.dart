import 'package:fitness_app/pages/AuthScreens/pages/login.dart';
import 'package:fitness_app/pages/AuthScreens/pages/registeration.dart';
import 'package:fitness_app/pages/homeScreen/pages/home.dart';
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
import 'package:google_fonts/google_fonts.dart';
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
              txtClr2: const Color(0xFF01FBE2),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ElevatedIconBttn(
                // isLoading: false,
                minWidth: 300.w,
                minHeigth: 40.h,
                elevationValue: 5.w,
                txt: 'Login',
                fontWt: FontWeight.bold,
                fontSz: 18.sp,
                ikon: Icons.email_outlined,
                txtClr: Colors.white,
                iconClr: Colors.white,
                mainaxisAlignment: MainAxisAlignment.center,
                iconSz: 20.w,
                width: 10.w,
                onClick: () => changeScreen(context, SignInScreen(),
                    PageTransitionType.bottomToTop, 200),
                bgClr: Colors.black,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ElevatedIconBttn(
                  // isLoading: false,
                  minWidth: 300.w,
                  minHeigth: 40.h,
                  elevationValue: 5.w,
                  txt: 'Register',
                  fontWt: FontWeight.bold,
                  fontSz: 18.sp,
                  ikon: Icons.list_alt_outlined,
                  bgClr: Colors.black,
                  mainaxisAlignment: MainAxisAlignment.center,
                  txtClr: Colors.white,
                  iconClr: Colors.white,
                  iconSz: 20.w,
                  width: 10.w,
                  onClick: () => changeScreen(context, const SignUpScreen(),
                      PageTransitionType.bottomToTop, 200)),
            ),
            Divider(
              height: 30.h,
              indent: 20.w,
              endIndent: 20.w,
              thickness: 1.w,
              color: ColorTemplates.textClr.withOpacity(.2),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300.w, 40.h),
                  backgroundColor: Colors.black,
                  elevation: 5.w,
                ),
                onPressed: () async {
                  try {
                    // Attempt to sign in with Google
                    final user = await authSerivce.signInWithGoogle(context);

                    if (user != null) {
                      // If user is successfully signed in, navigate to the home screen
                      changeScreenRemoveUntil(
                        context,
                        HomeScreen(),
                        PageTransitionType.rightToLeftWithFade,
                        200,
                      );
                      SnackBarWidget.show(
                          context, "You are signed in successfully");
                    } else {
                      // If user is null, show an error message
                      SnackBarWidget.show(
                          context, "Your Sign-In failed. Please try again.");
                    }
                  } catch (e) {
                    // Catch any errors during the sign-in process and show an error message
                    SnackBarWidget.show(
                      context,
                      "An error occurred during sign-in: ${e.toString()}",
                    );
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign in with ',
                      style: GoogleFonts.ubuntu(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Image.asset(
                      'assets/icons/google.png',
                      scale: 30.w,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
