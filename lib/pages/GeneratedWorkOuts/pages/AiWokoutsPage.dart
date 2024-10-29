import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class WorkoutPlanDisplayScreen extends StatelessWidget {
  final Map<String, dynamic>? workoutPlan;

  const WorkoutPlanDisplayScreen({Key? key, required this.workoutPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 15.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Your Workout Plan',
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            height: double.infinity,
            width: double.infinity,
            'assets/images/design2.png',
            fit: BoxFit.fitHeight,
            color: const Color(0xFF01FBE2),
          ),
          Positioned(
            bottom: -10,
            right: -10,
            child: Transform.rotate(
              angle: 80,
              child: Image.asset(
                'assets/images/design.png',
                height: 150.h,
                fit: BoxFit.contain,
                color: const Color(0xFF01FBE2).withOpacity(.4),
              ),
            ),
          ),
          workoutPlan == null
              ? Center(
                  child: Text(
                  'No workout plan generated.',
                  style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: workoutPlan!.entries
                        .map((entry) =>
                            _buildSection(context, entry.key, entry.value))
                        .toList(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, dynamic content) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(15.r)),
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ubuntu(
                  color: const Color(0xFF01FBE2),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Divider(
                height: 15.h,
              ),
              const SizedBox(height: 8),
              if (content is List)
                ...content.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      item.toString(),
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                )
              else
                Text(
                  content.toString(),
                  style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
