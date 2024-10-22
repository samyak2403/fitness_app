import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class UpperBodyStrength extends StatelessWidget {
  const UpperBodyStrength({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> equipments = [
      'assets/images/mat.png',
      'assets/images/mat.png',
      'assets/images/mat.png',
      'assets/images/mat.png',
      'assets/images/mat.png',
      'assets/images/mat.png',
      'assets/images/mat.png',
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Upper Body Strength',
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "11 Exercises | 15 mins | 70 - 80 Calories Burn",
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 10.h,
            ),
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
                        fontWeight: FontWeight.w800),
                  ),
                  trailing: Text(
                    'Beginner',
                    style: GoogleFonts.ubuntu(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  )),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'You\'ll Need',
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 120.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: equipments.length,
                itemBuilder: (context, index) {
                  return Row(children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFF01FBE2).withOpacity(.4),
                          borderRadius: BorderRadius.circular(20.r)),
                      height: 100.h,
                      width: 120.w,
                      child: Image.asset(
                        equipments[index],
                        scale: 12,
                      ),
                    ),
                    SizedBox(width: 10.w)
                  ]);
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Excercises',
              style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: equipments.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              // const Color(0xFF01FBE2),
                              const Color(0xFF01FBE2).withOpacity(.8),
                              const Color(0xFF01FBE2).withOpacity(.5),
                              const Color(0xFF01FBE2).withOpacity(.2),
                            ]),
                            // color: const Color(0xFF01FBE2).withOpacity(.4),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(equipments[index]),
                          ),
                          title: Text(
                            'Asd',
                            style: GoogleFonts.ubuntu(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            "15 mins",
                            style: GoogleFonts.ubuntu(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          trailing: Image.asset(
                            'assets/icons/Next.png',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      )
                    ],
                  );
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
