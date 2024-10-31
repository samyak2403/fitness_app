import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/pages/OnboardingScreens/pages/screen4.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/buttonWithIcon.dart';
import 'package:fitness_app/widgets/iconButton.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:fitness_app/widgets/text.dart';
import 'package:fitness_app/widgets/textField.dart';
import 'package:fitness_app/widgets/textsRichforOnboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _signUp() async {
    // Basic input validation
    if (firstnameController.text.isEmpty) {
      _showSnackBar('First name cannot be empty');
      return;
    }

    if (surnameController.text.isEmpty) {
      _showSnackBar('Surname cannot be empty');
      return;
    }

    if (phoneController.text.isEmpty) {
      _showSnackBar('Phone number cannot be empty');
      return;
    }

    if (!_isValidEmail(emailController.text)) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    if (passwordController.text.isEmpty || passwordController.text.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }

    // Proceed with signing up if validations pass
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        _showSnackBar(
            'Verification email has been sent. Please check your inbox.');
      }

      if (userCredential.user != null) {
        // Save user details to Firestore after successful sign-up
        await _firestore.collection('userdata').doc(emailController.text).set({
          'email': emailController.text,
          'firstname': firstnameController.text,
          'surname': surnameController.text,
          'phone': phoneController.text,
        });

        // Navigate to the home screen
        changeScreenRemoveUntil(
          context,
          OnboardingScreen4(),
          PageTransitionType.rightToLeftWithFade,
          200,
        );
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar(e.message.toString());
    } catch (e) {
      print("Error: $e");
    }
  }

// Email validation helper function
  bool _isValidEmail(String email) {
    // Simple regex for email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

// Show SnackBar for feedback
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: GoogleFonts.ubuntu(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
      backgroundColor: Colors.black,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          title: Txt(
              txt: 'Sign Up',
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                    height: 200.h,
                    width: 200.w,
                    child: LottieBuilder.asset(
                        'assets/lotties/authentication/login.json')),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.r),
                          topRight: Radius.circular(30.r))),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      children: [
                        TxtField(
                          visible: false,
                          controllername: firstnameController,
                          prefixikon: Icons.abc,
                          prefixikonClr: ColorTemplates.textClr,
                          suffixikonClr: ColorTemplates.textClr,
                          txt: 'Enter firstname',
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
                          keyboardType: TextInputType.name,
                        ),
                        TxtField(
                          visible: false,
                          controllername: surnameController,
                          prefixikon: Icons.abc,
                          prefixikonClr: ColorTemplates.textClr,
                          suffixikonClr: ColorTemplates.textClr,
                          txt: 'Enter surname',
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
                          topPad: 10.h,
                          bottomPad: 10.h,
                          obscure: false,
                          keyboardType: TextInputType.name,
                        ),
                        TxtField(
                          visible: false,
                          obscure: false,
                          leftPad: 20.w,
                          rightPad: 20.w,
                          topPad: 10.h,
                          bottomPad: 10.h,
                          controllername: emailController,
                          prefixikon: Icons.email_outlined,
                          prefixikonClr: ColorTemplates.textClr,
                          suffixikonClr: ColorTemplates.textClr,
                          txt: 'Enter email',
                          txtClr: ColorTemplates.textClr,
                          fontWt: FontWeight.w500,
                          focusedboarderrad: 10.r,
                          focusedClr: const Color(0xFF01FBE2),
                          focusedboarderwidth: 2.w,
                          enabledboarderrad: 10.r,
                          enabledClr: ColorTemplates.textClr,
                          enabledboarderwidth: 2.w,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TxtField(
                            visible: false,
                            obscure: false,
                            leftPad: 20.w,
                            rightPad: 20.w,
                            topPad: 10.h,
                            bottomPad: 10.h,
                            controllername: phoneController,
                            prefixikon: Icons.phone,
                            prefixikonClr: ColorTemplates.textClr,
                            suffixikonClr: ColorTemplates.textClr,
                            txt: 'Enter PhoneNumber',
                            txtClr: ColorTemplates.textClr,
                            fontWt: FontWeight.w500,
                            focusedboarderrad: 10.r,
                            focusedClr: const Color(0xFF01FBE2),
                            focusedboarderwidth: 2.w,
                            enabledboarderrad: 10.r,
                            enabledClr: ColorTemplates.textClr,
                            enabledboarderwidth: 2.w,
                            keyboardType: TextInputType.phone),
                        TxtField(
                            visible: true,
                            obscure: true,
                            leftPad: 20.w,
                            rightPad: 20.w,
                            topPad: 10.h,
                            bottomPad: 10.h,
                            controllername: passwordController,
                            prefixikon: Icons.password,
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
                          height: 20.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: ElevatedIconBttn(
                              minWidth: 320.w,
                              minHeigth: 40.h,
                              elevationValue: 5.w,
                              txt: 'Sign Up',
                              fontWt: FontWeight.bold,
                              fontSz: 20.w,
                              ikon: Icons.arrow_forward_ios_outlined,
                              bgClr: Colors.black,
                              mainaxisAlignment: MainAxisAlignment.center,
                              txtClr: Colors.white,
                              iconClr: Colors.white,
                              iconSz: 20.w,
                              onClick: _signUp,
                              width: 2.w),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextRich(
                          txt1: 'Be',
                          txtClr1: ColorTemplates.textClr,
                          fontWt1: FontWeight.bold,
                          fontSZ1: 20.sp,
                          txt2: 'Fit',
                          txtClr2: const Color(0xFF01FBE2),
                          fontWt2: FontWeight.bold,
                          fontSZ2: 20.sp,
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    ),
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
