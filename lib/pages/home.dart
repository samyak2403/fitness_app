import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/pages/HealthCalculators/pages/HealthCalculators.dart';
import 'package:fitness_app/pages/NutritionPlans/pages/PersonelDietPlans.dart';
import 'package:fitness_app/pages/QuickWorkouts/pages/quickWorkoutDetails.dart';
import 'package:fitness_app/pages/GeneratedWorkOuts/pages/AiGeneratedworkout.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/SearchFunctionality.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:fitness_app/widgets/text.dart';
import 'package:fitness_app/widgets/textsRichforOnboarding.dart';
import 'package:fitness_app/widgets/workoutList.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:ui'; // For BackdropFilter

class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final String email = FirebaseAuth.instance.currentUser!.email!;

  double? bmi;
  int? bmr;
  int? hrc;
  double? overallHealthPercentage;
  String? firstname;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchHealthData();
  }

  Future<void> _fetchHealthData() async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (userDoc.exists) {
        setState(() {
          bmi = userDoc['BMI']?['value']?.toDouble();
          bmr = userDoc['BMR']?['value']?.toInt();
          hrc = userDoc['HRC']?['value']?.toInt();
          overallHealthPercentage =
              userDoc['OverallHealthPercentage']?['value']?.toDouble();
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userinfo = await FirebaseFirestore.instance
          .collection('userdata')
          .doc(email)
          .get();

      if (userinfo.exists) {
        setState(() {
          firstname = userinfo['firstname'];
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Map<String, double> _calculateHealthPercentages() {
    // Define max values for normalization
    const double maxBmi = 25.0; // Maximum healthy BMI
    const double maxBmr = 100.0; // Maximum resting heart rate
    const double maxHrc = 180.0; // Maximum heart rate during exercise

    // Calculate normalized percentages
    double bmiPercentage = ((bmi ?? 0) / maxBmi) * 100;
    double bmrPercentage = ((bmr ?? 0) / maxBmr) * 100;
    double hrcPercentage = ((hrc ?? 0) / maxHrc) * 100;

    // Ensure values do not exceed 100
    bmiPercentage = bmiPercentage.clamp(0, 100);
    bmrPercentage = bmrPercentage.clamp(0, 100);
    hrcPercentage = hrcPercentage.clamp(0, 100);

    // Calculate total of normalized percentages
    double total = bmiPercentage + bmrPercentage + hrcPercentage;

    // Normalize them if the total exceeds 100
    if (total > 100) {
      bmiPercentage = (bmiPercentage / total) * 100;
      bmrPercentage = (bmrPercentage / total) * 100;
      hrcPercentage = (hrcPercentage / total) * 100;
    }

    double remainingPercentage =
        100 - (bmiPercentage + bmrPercentage + hrcPercentage);

    return {
      'BMI': bmiPercentage,
      'BMR': bmrPercentage,
      'HRC': hrcPercentage,
      'Remaining': remainingPercentage,
    };
  }

  void _showQuickWorkoutOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a Quick Workout',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...Workouts()
                  .quickWorkouts
                  .map((workout) => _buildWorkoutTile(context, workout))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkoutTile(BuildContext context, Map<String, dynamic> workout) {
    return ListTile(
      title: Text(workout['name']),
      subtitle: Text('${workout['duration']} • ${workout['difficulty']}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _startQuickWorkout(context, workout),
    );
  }

  void _startQuickWorkout(BuildContext context, Map<String, dynamic> workout) {
    Navigator.pop(context); // Close the bottom sheet
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuickWorkoutDetailScreen(
          workoutName: workout['name'],
          gifUrl: workout['gifUrl'],
          description: workout['description'],
          exercises: List<String>.from(workout['exercises']),
          duration: workout['duration'],
          difficulty: workout['difficulty'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> healthPercentages = _calculateHealthPercentages();

    double baseRadius = 10.0; // Base radius for the smallest section
    double maxRadius = 40.0; // Maximum radius for the largest section

// Assuming healthPercentages has been calculated correctly
    double bmiPercentage = healthPercentages['BMI']!;
    double bmrPercentage = healthPercentages['BMR']!;
    double hrcPercentage = healthPercentages['HRC']!;

// Find the maximum percentage
    double maxPercentage = [bmiPercentage, bmrPercentage, hrcPercentage]
        .reduce((a, b) => a > b ? a : b);

// Calculate dynamic radius based on the percentage
    double bmiRadius = baseRadius +
        ((bmiPercentage / maxPercentage) * (maxRadius - baseRadius));
    double bmrRadius = baseRadius +
        ((bmrPercentage / maxPercentage) * (maxRadius - baseRadius));
    double hrcRadius = baseRadius +
        ((hrcPercentage / maxPercentage) * (maxRadius - baseRadius));
    return Scaffold(
      backgroundColor: ColorTemplates.primary,
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 235.h,
                width: 370.w,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 65.h,
                        ),
                        Container(
                          height: 150.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                              color: const Color(0xFF01FBE2),
                              borderRadius: BorderRadius.circular(15.r)),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: SvgPicture.asset(
                                    'assets/svg/circle.svg',
                                    color: Color(0xFF08EBE2),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Positioned(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20.r,
                                            backgroundImage: const AssetImage(
                                                'assets/images/male_profile.png'),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          TextRich(
                                              txt1: 'Hi, ',
                                              txtClr1: Colors.black,
                                              fontWt1: FontWeight.w500,
                                              fontSZ1: 20.sp,
                                              txt2: firstname.toString(),
                                              txtClr2: Colors.black,
                                              fontWt2: FontWeight.bold,
                                              fontSZ2: 20.sp),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: -15.w,
                      child: SizedBox(
                        height: 300,
                        width: 250,
                        child: Image.asset(
                          'assets/images/model.png',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
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
                                color: Color(0xFF08EBE2),
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold)),
                        TyperAnimatedText('Nutrition...',
                            speed: Duration(milliseconds: 200),
                            textStyle: GoogleFonts.ubuntu(
                                color: Color(0xFF08EBE2),
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold)),
                        TyperAnimatedText('Calculators...',
                            speed: Duration(milliseconds: 200),
                            textStyle: GoogleFonts.ubuntu(
                                color: Color(0xFF08EBE2),
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold)),
                        TyperAnimatedText('Yoga\'s...',
                            speed: Duration(milliseconds: 200),
                            textStyle: GoogleFonts.ubuntu(
                                color: Color(0xFF08EBE2),
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold)),
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              SearchScreen(
                email: email,
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250.h,
                        width: 230.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // border: Border.all(color: Color(0xFF08EBE2)),
                          color: Color(0xFF08EBE2),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  // color: Color.fromARGB(255, 0, 140, 255),
                                  color: Colors.black87,
                                  value: bmiPercentage,
                                  radius: bmiRadius.r,
                                  title: bmiPercentage.toStringAsFixed(0) + '%',
                                  titleStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  // color: const Color.fromARGB(255, 255, 32, 16),
                                  color: Colors.black54,
                                  value: bmrPercentage,
                                  radius: bmrRadius.r,
                                  title: bmrPercentage.toStringAsFixed(0) + '%',
                                  titleStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  // color: const Color.fromARGB(255, 253, 227, 0),
                                  color: Colors.black26,
                                  value: hrcPercentage,
                                  radius: hrcRadius.r,
                                  title: hrcPercentage.toStringAsFixed(0) + '%',
                                  titleStyle: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 100.h,
                        left: 80.w,
                        child: Column(
                          children: [
                            Txt(
                              txt: overallHealthPercentage != null
                                  ? overallHealthPercentage!.toStringAsFixed(0)
                                  : '0',
                              fontSz: 30.sp,
                              fontWt: FontWeight.bold,
                              txtClr: ColorTemplates.primary,
                            ),
                            Txt(
                              txt: 'of 100%',
                              fontSz: 15.sp,
                              fontWt: FontWeight.bold,
                              txtClr: ColorTemplates.primary,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10.h,
                        left: 40.w,
                        child: Txt(
                          txt: 'Overall Health',
                          fontSz: 20.sp,
                          fontWt: FontWeight.bold,
                          txtClr: ColorTemplates.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    width: 80.w,
                    height: 250.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorTemplates.primary),
                      color: ColorTemplates.textClr,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => changeScreen(
                                context,
                                HealthCalculatorsScreen(userEmail: email),
                                PageTransitionType.leftToRightWithFade,
                                300),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: LottieBuilder.asset(
                                      'assets/lotties/cal.json'),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Txt(
                                  txt: bmi != null
                                      ? bmi!.toStringAsFixed(2)
                                      : 'N/A',
                                  fontSz: 10.sp,
                                  fontWt: FontWeight.bold,
                                  txtClr: Color(0xFF08EBE2),
                                ),
                                Txt(
                                  txt: 'BMI',
                                  fontSz: 10.sp,
                                  fontWt: FontWeight.bold,
                                  txtClr: Color(0xFF08EBE2),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                              indent: 8.w,
                              endIndent: 8.w,
                              color: Color(0xFF08EBE2)),
                          InkWell(
                            onTap: () => changeScreen(
                                context,
                                HealthCalculatorsScreen(userEmail: email),
                                PageTransitionType.leftToRightWithFade,
                                300),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: LottieBuilder.asset(
                                      'assets/lotties/flame.json'),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Txt(
                                    txt: bmr != null ? bmr.toString() : 'N/A',
                                    fontSz: 10.sp,
                                    fontWt: FontWeight.bold,
                                    txtClr: Color(0xFF08EBE2)),
                                Txt(
                                    txt: 'BMR',
                                    fontSz: 10.sp,
                                    fontWt: FontWeight.bold,
                                    txtClr: Color(0xFF08EBE2)),
                              ],
                            ),
                          ),
                          Divider(
                              indent: 8.w,
                              endIndent: 8.w,
                              color: Color(0xFF08EBE2)),
                          InkWell(
                            onTap: () => changeScreen(
                                context,
                                HealthCalculatorsScreen(userEmail: email),
                                PageTransitionType.leftToRightWithFade,
                                300),
                            child: Column(
                              children: [
                                SizedBox(height: 6.h),
                                SizedBox(
                                  height: 25.h,
                                  width: 25.h,
                                  child: LottieBuilder.asset(
                                      'assets/lotties/heart1.json'),
                                ),
                                SizedBox(height: 5.h),
                                Txt(
                                  txt: hrc != null ? hrc.toString() : 'N/A',
                                  fontSz: 10.sp,
                                  fontWt: FontWeight.bold,
                                  txtClr: Color(0xFF08EBE2),
                                ),
                                Txt(
                                  txt: 'HRC',
                                  fontSz: 10.sp,
                                  fontWt: FontWeight.bold,
                                  txtClr: Color(0xFF08EBE2),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () => changeScreen(context, GenerateWorkoutPlanScreen(),
                    PageTransitionType.leftToRightWithFade, 300),
                child: Container(
                  width: 300.w,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset('assets/images/workout.jpg')),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Generate Workout Plans",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Create a personalized workout plan tailored to your goals and experience level.",
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () => _showQuickWorkoutOptions(context),
                child: Container(
                  width: 300.w,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset('assets/images/workout1.jpg')),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Quick Start",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Need a quick workout? Try our pre-made plans",
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () => changeScreen(context, GenerateDietPlanScreen(),
                    PageTransitionType.leftToRightWithFade, 300),
                child: Container(
                  width: 300.w,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset('assets/images/workout.jpg')),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Generate Workout Plans",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Create a personalized workout plan tailored to your goals and experience level.",
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () => changeScreen(
                    context,
                    HealthCalculatorsScreen(
                      userEmail: email,
                    ),
                    PageTransitionType.leftToRightWithFade,
                    300),
                child: Container(
                  width: 300.w,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.asset('assets/images/workout.jpg')),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Generate Workout Plans",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Create a personalized workout plan tailored to your goals and experience level.",
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 20,
                          ),
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
