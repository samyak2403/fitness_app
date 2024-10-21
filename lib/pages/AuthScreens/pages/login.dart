import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/pages/AuthScreens/pages/forgotPassword.dart';
import 'package:fitness_app/pages/home.dart';
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
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SignInScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.emailVerified) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please verify your email to log in.')));
        await FirebaseAuth.instance.signOut();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
    // finally {
    //   ref.read(loadingProvider.notifier).state = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final isLoading = ref.watch(loadingProvider);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Txt(
              txt: 'Sign In',
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
                                  300)),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        ElevatedIconBttn(
                          maxWidth: 320.w,
                          maxHeigth: 40.h,
                          elevationValue: 5.w,
                          txt: 'Sign In',
                          fontWt: FontWeight.bold,
                          fontSz: 20.w,
                          ikon: Icons.arrow_forward_ios_outlined,
                          bgClr: ColorTemplates.buttonClr,
                          mainaxisAlignment: MainAxisAlignment.center,
                          txtClr: ColorTemplates.textClr,
                          iconClr: ColorTemplates.textClr,
                          iconSz: 20.w,
                          onClick: _signIn,
                          width: 2.w,
                          // isLoading: isLoading,
                        ),
                        SizedBox(
                          height: 100.h,
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
        ),
      ),
    );
  }
}
