import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/pages/QuickWorkouts/pages/ExerciseScreen.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class CoreCrusherList extends StatefulWidget {
  const CoreCrusherList({super.key});

  @override
  State<CoreCrusherList> createState() => _CoreCrusherListState();
}

class _CoreCrusherListState extends State<CoreCrusherList> {
  Future<DocumentSnapshot> getWorkout() async {
    try {
      return await FirebaseFirestore.instance
          .collection('quick_Workout')
          .doc('Core_Cusher')
          .get();
    } catch (e) {
      log("Some error occurred: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> equipments = [
      'assets/images/mat.png',
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Core Crusher',
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "11 Exercises | 15 mins | 70 - 80 Calories Burn",
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: const Color(0xFF01FBE2),
                ),
                child: ListTile(
                  leading: Image.asset(
                    'assets/icons/Difficulity.png',
                    color: Colors.black,
                  ),
                  title: Text(
                    'Difficulty Level',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  trailing: Text(
                    'Beginner',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'You\'ll Need',
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(
                height: 120.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: equipments.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF01FBE2).withOpacity(.4),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          height: 100.h,
                          width: 120.w,
                          child: Image.asset(
                            equipments[index],
                            scale: 12,
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Exercises',
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: FutureBuilder<DocumentSnapshot>(
                  future: getWorkout(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    }
                    if (!snapshot.hasData || snapshot.data!.data() == null) {
                      log(snapshot.data.toString());
                      return const Center(child: Text('No data found'));
                    }

                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    log(data.length.toString());
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String key = (index + 1).toString();

                        if (!data.containsKey(key)) return const SizedBox();

                        return Column(
                          children: [
                            InkWell(
                              onTap: () => changeScreen(
                                  context,
                                  ExerciseScreen(index: key),
                                  PageTransitionType.leftToRight,
                                  300),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF01FBE2).withOpacity(.8),
                                      const Color(0xFF01FBE2).withOpacity(.5),
                                      const Color(0xFF01FBE2).withOpacity(.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(15.r),
                                    child: Image.asset(equipments[0]),
                                  ),
                                  title: Text(
                                    data[key]['name'],
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  subtitle: Text(
                                    data[key]['duration'],
                                    style: GoogleFonts.ubuntu(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Image.asset(
                                    'assets/icons/Next.png',
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
