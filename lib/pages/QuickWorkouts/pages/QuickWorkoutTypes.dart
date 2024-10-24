import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import 'package:fitness_app/pages/QuickWorkouts/Widgets/ExerciseVideo.dart';
import 'package:fitness_app/widgets/navigator.dart';

class QuickWorkoutTypes extends StatefulWidget {
  final String doc;
  final String workoutName;
  final String level;
  final String duration;
  final String exercises;
  final String calories;
  final String workoutImagesFolder;

  QuickWorkoutTypes({
    Key? key,
    required this.doc,
    required this.workoutName,
    required this.level,
    required this.duration,
    required this.exercises,
    required this.calories,
    required this.workoutImagesFolder,
  }) : super(key: key);

  @override
  State<QuickWorkoutTypes> createState() => _QuickWorkoutTypesState();
}

class _QuickWorkoutTypesState extends State<QuickWorkoutTypes> {
  Future<DocumentSnapshot> getWorkout() async {
    try {
      return await FirebaseFirestore.instance
          .collection('quick_Workout')
          .doc(widget.doc)
          .get();
    } catch (e) {
      log("Some error occurred: $e");
      rethrow;
    }
  }

  Future<Map<String, List<String>>> fetchImageUrls() async {
    try {
      Map<String, List<String>> imageUrlsMap = {
        widget.workoutImagesFolder: [],
        'workouts_photo': []
      };

      ListResult coreCrusherResult = await FirebaseStorage.instance
          .ref(widget.workoutImagesFolder)
          .listAll();

      for (var ref in coreCrusherResult.items) {
        String url = await ref.getDownloadURL();
        imageUrlsMap[widget.workoutImagesFolder]!.add(url);
      }

      ListResult workoutsPhotoResult =
          await FirebaseStorage.instance.ref('workouts_photo').listAll();

      for (var ref in workoutsPhotoResult.items) {
        String url = await ref.getDownloadURL();
        imageUrlsMap['workouts_photo']!.add(url);
      }

      return imageUrlsMap;
    } catch (e) {
      log("Error fetching images: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.workoutName,
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "${widget.exercises} Exercises | ${widget.duration} | ${widget.calories} Calories Burn",
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
                    widget.level,
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
              FutureBuilder<Map<String, List<String>>>(
                future: fetchImageUrls(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SizedBox(
                            height: 100.h,
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: Colors.black,
                            ))));
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text('Error loading images'));
                  }

                  if (!snapshot.hasData ||
                      snapshot.data![widget.workoutImagesFolder] == null ||
                      snapshot.data![widget.workoutImagesFolder]!.isEmpty) {
                    return const Center(child: Text('No images found'));
                  }

                  List<String> coreCrusherUrls =
                      snapshot.data![widget.workoutImagesFolder]!;

                  return SizedBox(
                    height: 100.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: coreCrusherUrls.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF01FBE2).withOpacity(.4),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              height: 80.h,
                              width: 100.w,
                              child: Image.network(
                                coreCrusherUrls[index],
                              ),
                            ),
                            SizedBox(width: 10.w),
                          ],
                        );
                      },
                    ),
                  );
                },
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
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    }
                    if (!snapshot.hasData || snapshot.data!.data() == null) {
                      log(snapshot.data.toString());
                      return const Center(
                        child: Text('No data found'),
                      );
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
                                  leading: SizedBox(
                                    width:
                                        50, // Set a specific width for the leading widget
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.r),
                                      child: FutureBuilder<
                                          Map<String, List<String>>>(
                                        future: fetchImageUrls(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData ||
                                              snapshot.data![
                                                      'workouts_photo'] ==
                                                  null) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                              color: Colors.black,
                                            )); // Handle loading state
                                          }
                                          List<String> workoutImageUrls =
                                              snapshot.data!['workouts_photo']!;
                                          return Image.network(
                                            workoutImageUrls[index],
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
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
