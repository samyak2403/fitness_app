import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/pages/home.dart';
import 'package:fitness_app/pages/onboardingScreens/screen4.dart';
import 'package:fitness_app/services/services.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/buttonWithIcon.dart';
import 'package:fitness_app/widgets/iconButton.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:fitness_app/widgets/text.dart';
import 'package:fitness_app/widgets/textField.dart';
import 'package:fitness_app/widgets/textsRichforOnboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signUp() async {
    try {
      await ref.read(authServiceProvider).signUp(
            emailController.text,
            passwordController.text,
          );
      changeScreenRemoveUntil(
          context, HomeScreen(), PageTransitionType.rightToLeftWithFade, 300);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Txt(
                txt: 'Sign Up',
                fontSz: 25.sp,
                fontWt: FontWeight.bold,
                txtClr: ColorTemplates.textClr),
            backgroundColor: ColorTemplates.buttonClr,
            leading: IconBttn(
                onClick: () => changeScreen(context, const OnboardingScreen4(),
                    PageTransitionType.leftToRightWithFade, 300),
                ikon: Icons.arrow_back_ios_new_rounded,
                ikonClr: ColorTemplates.textClr,
                ikonSz: 20.w)),
        backgroundColor: ColorTemplates.buttonClr,
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              SizedBox(
                  height: 200.h,
                  width: 200.w,
                  child: LottieBuilder.asset(
                      'assets/lotties/authentication/login.json')),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: ColorTemplates.primary,
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
                          controllername: nameController,
                          prefixikon: Icons.email_outlined,
                          prefixikonClr: ColorTemplates.textClr,
                          suffixikonClr: ColorTemplates.textClr,
                          txt: 'Enter name',
                          txtClr: ColorTemplates.textClr,
                          fontWt: FontWeight.w500,
                          focusedboarderrad: 10.r,
                          focusedClr: ColorTemplates.buttonClr,
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
                          focusedClr: ColorTemplates.buttonClr,
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
                            prefixikon: Icons.email_outlined,
                            prefixikonClr: ColorTemplates.textClr,
                            suffixikonClr: ColorTemplates.textClr,
                            txt: 'Enter PhoneNumber',
                            txtClr: ColorTemplates.textClr,
                            fontWt: FontWeight.w500,
                            focusedboarderrad: 10.r,
                            focusedClr: ColorTemplates.buttonClr,
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
                            prefixikon: Icons.email_outlined,
                            prefixikonClr: ColorTemplates.textClr,
                            suffixikonClr: ColorTemplates.textClr,
                            txt: 'Enter Password',
                            txtClr: ColorTemplates.textClr,
                            fontWt: FontWeight.w500,
                            focusedboarderrad: 10.r,
                            focusedClr: ColorTemplates.buttonClr,
                            focusedboarderwidth: 2.w,
                            enabledboarderrad: 10.r,
                            enabledClr: ColorTemplates.textClr,
                            enabledboarderwidth: 2.w,
                            keyboardType: TextInputType.name),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ElevatedIconBttn(
                            maxWidth: 320.w,
                            maxHeigth: 40.h,
                            elevationValue: 5.w,
                            txt: 'Sign Up',
                            fontWt: FontWeight.bold,
                            fontSz: 20.w,
                            ikon: Icons.arrow_forward_ios_outlined,
                            bgClr: ColorTemplates.buttonClr,
                            mainaxisAlignment: MainAxisAlignment.center,
                            txtClr: ColorTemplates.textClr,
                            iconClr: ColorTemplates.textClr,
                            iconSz: 20.w,
                            onClick: _signUp,
                            width: 2.w),
                        SizedBox(
                          height: 20.h,
                        ),
                        TextRich(
                          txt1: 'BodyFit.',
                          txtClr1: ColorTemplates.textClr,
                          fontWt1: FontWeight.bold,
                          fontSZ1: 20.sp,
                          txt2: 'io',
                          txtClr2: ColorTemplates.buttonClr,
                          fontWt2: FontWeight.bold,
                          fontSZ2: 20.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
