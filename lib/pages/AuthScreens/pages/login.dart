import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/pages/AuthScreens/pages/forgotPassword.dart';
import 'package:fitness_app/pages/homeScreen/pages/home.dart';
import 'package:fitness_app/pages/OnboardingScreens/pages/screen4.dart';
import 'package:fitness_app/pages/AuthScreens/services/services.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/buttonWithIcon.dart';
import 'package:fitness_app/widgets/iconButton.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:fitness_app/widgets/text.dart';
import 'package:fitness_app/widgets/textButton.dart';
import 'package:fitness_app/widgets/textField.dart';
import 'package:fitness_app/widgets/textsRichforOnboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _signIn() async {
    try {
      // Attempt to sign in with the provided email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Get shared preferences to check email verification status
        final prefs = await SharedPreferences.getInstance();
        bool isEmailVerified = prefs.getBool('isEmailVerified') ?? false;

        // If email is not verified
        if (!isEmailVerified && !user.emailVerified) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              'Please verify your email to log in.',
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ));
          await FirebaseAuth.instance.signOut(); // Log the user out
        } else {
          // Update email verification status in SharedPreferences
          if (user.emailVerified) {
            await prefs.setBool('isEmailVerified', true);
          }

          changeScreenRepalcement(
              context, HomeScreen(), PageTransitionType.bottomToTop, 200);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.black,
            content: Text(
              'You are logged in successfully.',
              style: GoogleFonts.ubuntu(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ));
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle wrong credentials or other Firebase exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            e.code == 'user-not-found'
                ? "User not found. Please check your email."
                : "Invalid credentials. Please try again.",
            style: GoogleFonts.ubuntu(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
      log(e.message!); // Log the error message for debugging
    } catch (e) {
      // Handle any other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          'An unexpected error occurred. Please try again later.',
          style: GoogleFonts.ubuntu(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ));
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = kToolbarHeight;
    log(appBarHeight.h.toString());
    final height = MediaQuery.of(context).size.height;
    final containerHeight = height - (200.h + appBarHeight.h + 27);
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          title: Txt(
              txt: 'Sign In',
              fontSz: 25.sp,
              fontWt: FontWeight.bold,
              txtClr: ColorTemplates.textClr),
          backgroundColor: const Color(0xFF01FBE2),
          leading: IconBttn(
              onClick: () => changeScreen(context, const OnboardingScreen4(),
                  PageTransitionType.leftToRightWithFade, 200),
              ikon: Icons.arrow_back_ios_new_rounded,
              ikonClr: ColorTemplates.textClr,
              ikonSz: 20.w)),
      backgroundColor: const Color(0xFF01FBE2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                    height: 200.h,
                    width: 200.w,
                    child: LottieBuilder.asset(
                        'assets/lotties/authentication/login.json')),
                Container(
                  height: containerHeight,
                  decoration: BoxDecoration(
                      color: ColorTemplates.primary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r))),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          TxtField(
                            visible: false,
                            controllername: emailController,
                            prefixikon: Icons.email_outlined,
                            prefixikonClr: ColorTemplates.textClr,
                            suffixikonClr: ColorTemplates.textClr,
                            txt: 'Enter Email',
                            txtClr: ColorTemplates.textClr,
                            fontWt: FontWeight.w500,
                            focusedboarderrad: 10.r,
                            focusedClr: const Color(0xFF01FBE2),
                            focusedboarderwidth: 2.w,
                            enabledboarderrad: 10.r,
                            enabledClr: ColorTemplates.textClr,
                            enabledboarderwidth: 2.w,
                            leftPad: 20.w,
                            rightPad: 20.w,
                            topPad: 30.h,
                            bottomPad: 10.h,
                            obscure: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TxtField(
                              visible: true,
                              obscure: true,
                              leftPad: 20.w,
                              rightPad: 20.w,
                              topPad: 10.h,
                              bottomPad: 10.h,
                              controllername: passwordController,
                              prefixikon: Icons.password_outlined,
                              prefixikonClr: ColorTemplates.textClr,
                              suffixikonClr: ColorTemplates.textClr,
                              txt: 'Enter Password',
                              txtClr: ColorTemplates.textClr,
                              fontWt: FontWeight.w500,
                              focusedboarderrad: 10.r,
                              focusedClr: const Color(0xFF01FBE2),
                              focusedboarderwidth: 2.w,
                              enabledboarderrad: 10.r,
                              enabledClr: ColorTemplates.textClr,
                              enabledboarderwidth: 2.w,
                              keyboardType: TextInputType.name),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: TxtButton(
                                txtClr: ColorTemplates.textClr,
                                txt: 'Forgot password',
                                fontWt: FontWeight.w500,
                                fontSz: 15.w,
                                ikon: Icons.question_mark_outlined,
                                mainaxisAlignment: MainAxisAlignment.end,
                                iconClr: ColorTemplates.textClr,
                                iconSz: 15.w,
                                onClick: () => changeScreen(
                                    context,
                                    const ForgotPassword(),
                                    PageTransitionType.bottomToTop,
                                    200)),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: ElevatedIconBttn(
                              minWidth: 320.w,
                              minHeigth: 40.h,
                              elevationValue: 5.w,
                              txt: 'Sign In',
                              fontWt: FontWeight.bold,
                              fontSz: 20.w,
                              ikon: Icons.arrow_forward_ios_outlined,
                              bgClr: ColorTemplates.textClr,
                              mainaxisAlignment: MainAxisAlignment.center,
                              txtClr: Colors.white,
                              iconClr: Colors.white,
                              iconSz: 20.w,
                              onClick: _signIn,
                              width: 2.w,
                              // isLoading: isLoading,
                            ),
                          ),
                          SizedBox(
                              height: 80.h), // Give enough space for TextRich
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: TextRich(
                            txt1: 'BodyFit.',
                            txtClr1: ColorTemplates.textClr,
                            fontWt1: FontWeight.bold,
                            fontSZ1: 20.sp,
                            txt2: 'io',
                            txtClr2: const Color(0xFF01FBE2),
                            fontWt2: FontWeight.bold,
                            fontSZ2: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
