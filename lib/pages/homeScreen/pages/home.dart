import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/pages/HealthCalculators/pages/HealthCalculators.dart';
import 'package:fitness_app/pages/NutritionPlans/pages/PersonelDietPlans.dart';
import 'package:fitness_app/pages/QuickWorkouts/pages/QuickWorkoutTypes.dart';
import 'package:fitness_app/pages/GeneratedWorkOuts/pages/AiGeneratedworkout.dart';
import 'package:fitness_app/pages/homeScreen/widgets/CalculatorValues.dart';
import 'package:fitness_app/pages/homeScreen/widgets/animatedText.dart';
import 'package:fitness_app/pages/homeScreen/widgets/calculatorReadings.dart';
import 'package:fitness_app/utils/colors.dart';
import 'package:fitness_app/widgets/SearchFunctionality.dart';
import 'package:fitness_app/pages/homeScreen/widgets/card.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:fitness_app/widgets/text.dart';
import 'package:fitness_app/widgets/textsRichforOnboarding.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  bool _isLoading = true;

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
          log(overallHealthPercentage.toString());
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
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Map<String, double> _calculateHealthPercentages() {
    const double maxBmi = 25.0;
    const double maxBmr = 100.0;
    const double maxHrc = 180.0;

    double bmiPercentage = ((bmi ?? 0) / maxBmi) * 100;
    double bmrPercentage = ((bmr ?? 0) / maxBmr) * 100;
    double hrcPercentage = ((hrc ?? 0) / maxHrc) * 100;

    bmiPercentage = bmiPercentage.clamp(0, 100);
    bmrPercentage = bmrPercentage.clamp(0, 100);
    hrcPercentage = hrcPercentage.clamp(0, 100);

    double total = bmiPercentage + bmrPercentage + hrcPercentage;

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

  Map<String, Map<String, String>> quickworkoutInfo = {
    'Core Crusher': {
      'duration': '15 min',
      'level': 'Beginner',
      'Excercises': '11',
      'calories': '70-80',
      'folder': 'core_crusher'
    },
    'Full Body Workout': {
      'duration': '20 min',
      'level': 'Intermediate',
      'Excercises': '15',
      'calories': '120-130',
      'folder': 'full_body_hiit'
    },
    'Upper Body Strength': {
      'duration': '30 min',
      'level': 'Advanced',
      'Excercises': '20',
      'calories': '150-180',
      'folder': 'upper_body'
    },
  };

  List<String> collectionName = [
    'Core_Cusher',
    'Full_Body_HIIT',
    'Upper_Body_Strength'
  ];
  // List<String> time = [
  //   '15 min • Beginner',
  //   '20 min • Intermediate',
  //   '30 min • Advanced'
  // ];

  void _showQuickWorkoutOptions(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.black,
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
              Center(
                child: Text(
                  'Choose a Quick Workout',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ubuntu(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              ListView.builder(
                itemCount: quickworkoutInfo.length,
                shrinkWrap: true, // Important for nested ListViews in a Column
                itemBuilder: (context, index) {
                  // Get the workout name (outer map key) at the current index
                  String workoutName = quickworkoutInfo.keys.elementAt(index);
                  // Get the nested map (duration, level, exercises)
                  Map<String, String> workoutDetails =
                      quickworkoutInfo[workoutName]!;

                  // Extract the duration, level, and exercises from the nested map
                  String duration =
                      workoutDetails['duration']!; // e.g., '15 min'
                  String level = workoutDetails['level']!; // e.g., 'Beginner'
                  String exercises =
                      workoutDetails['Excercises']!; // e.g., '11'
                  String calories = workoutDetails['calories']!;
                  String folder = workoutDetails['folder']!;

                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            workoutName, // Display workout name
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          subtitle: Text(
                            '$duration | $level | $exercises Exercises', // Display duration, level, and exercises
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuickWorkoutTypes(
                                  doc: collectionName[
                                      index], // Assuming you have collectionName
                                  workoutName: workoutName,
                                  level: level,
                                  duration: duration,
                                  exercises: exercises, calories: calories,
                                  workoutImagesFolder: folder,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void signOut() async {
    User? user = _auth.currentUser;

    if (user != null) {
      for (UserInfo provider in user.providerData) {
        if (provider.providerId == 'google.com') {
          await _googleSignIn.signOut();
          break;
        } else {
          await _auth.signOut();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> healthPercentages = _calculateHealthPercentages();

    double baseRadius = 10.0;
    double maxRadius = 40.0;

    double bmiPercentage = healthPercentages['BMI']!;
    double bmrPercentage = healthPercentages['BMR']!;
    double hrcPercentage = healthPercentages['HRC']!;

    double maxPercentage = [bmiPercentage, bmrPercentage, hrcPercentage]
        .reduce((a, b) => a > b ? a : b);

    double bmiRadius = baseRadius +
        ((bmiPercentage / maxPercentage) * (maxRadius - baseRadius));
    double bmrRadius = baseRadius +
        ((bmrPercentage / maxPercentage) * (maxRadius - baseRadius));
    double hrcRadius = baseRadius +
        ((hrcPercentage / maxPercentage) * (maxRadius - baseRadius));
    return Scaffold(
      backgroundColor: ColorTemplates.primary,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: SvgPicture.asset(
                                          'assets/svg/circle.svg',
                                          color: Colors.black.withOpacity(.3),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 0,
                                        child: Image.asset(
                                          'assets/images/design.png',
                                          height: 80,
                                        )),
                                    Padding(
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
                                            fontSZ2: 20.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              top: 20,
                              child: InkWell(
                                onTap: () => signOut(),
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black26),
                                      borderRadius:
                                          BorderRadius.circular(30.r)),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/Setting.png',
                                      height: 50,
                                    ),
                                  ),
                                ),
                              )),
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
                    const AnimatedTxt(),
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
                                // border: Border.all(color: const Color(0xFF08EBE2)),
                                color: const Color(0xFF08EBE2),
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
                                        title:
                                            bmiPercentage.toStringAsFixed(0) +
                                                '%',
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
                                        title:
                                            bmrPercentage.toStringAsFixed(0) +
                                                '%',
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
                                        title:
                                            hrcPercentage.toStringAsFixed(0) +
                                                '%',
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
                                        ? overallHealthPercentage!
                                            .toStringAsFixed(0)
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
                                txtClr: Colors.white,
                              ),
                            ),
                            // Positioned(bottom: 0, child: Text("sjdjs"))
                            const CalculatorValues()
                          ],
                        ),
                        SizedBox(width: 10.w),
                        CalculatorReadings(
                            onClick: () => changeScreen(
                                context,
                                HealthCalculatorsScreen(userEmail: email),
                                PageTransitionType.leftToRightWithFade,
                                300),
                            bmi: bmi!,
                            bmr: bmr!,
                            hrc: hrc!)
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "See All",
                      style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Cards(
                            mainImage: 'assets/images/workout1.jpg',
                            title: 'Quick Workout Tutorials',
                            desc:
                                'Need a quick workout? Try our Pre-mode workout plans.',
                            onClick: () => _showQuickWorkoutOptions(context),
                            bttnText: 'Start Workout',
                            modelImage: 'assets/images/model1.png',
                            height: 200.h,
                            width: 200.w,
                            left: 140.w,
                            bottom: 0.h,
                          ),
                          Cards(
                            mainImage: 'assets/images/workout.jpg',
                            title: 'Generate Workout Plans',
                            desc:
                                'Create a personalized workout plan tailored to your goals and experience level.',
                            onClick: () => changeScreen(
                                context,
                                const GenerateWorkoutPlanScreen(),
                                PageTransitionType.leftToRightWithFade,
                                300),
                            bttnText: 'Start to Generate',
                            modelImage: 'assets/images/workout2.png',
                            height: 210.h,
                            width: 90.w,
                            left: 200.w,
                            bottom: 0.h,
                          ),
                          Cards(
                            mainImage: 'assets/images/workout.jpg',
                            title: 'Generate Diet Plans',
                            desc:
                                'Create a personalized nutrition plan tailored to your dietary needs and health goals.',
                            onClick: () => changeScreen(
                                context,
                                const GenerateDietPlanScreen(),
                                PageTransitionType.leftToRightWithFade,
                                300),
                            bttnText: 'Get Diet Plan',
                            modelImage: 'assets/images/workout3.png',
                            height: 150.h,
                            width: 150.w,
                            left: 150.w,
                            bottom: 40,
                          ),
                          Cards(
                            mainImage: 'assets/images/workout1.jpg',
                            title: 'Health CalCulators',
                            desc:
                                'Develop a personalized set of health calculators to track your fitness metrics.',
                            onClick: () => changeScreen(
                                context,
                                HealthCalculatorsScreen(
                                  userEmail: email,
                                ),
                                PageTransitionType.leftToRightWithFade,
                                300),
                            bttnText: 'Calculate health',
                            modelImage: 'assets/images/workout3.png',
                            height: 150.h,
                            width: 150.w,
                            left: 150.w,
                            bottom: 40,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
