import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Cards extends StatelessWidget {
  String mainImage;
  double height;
  double width;
  String title;
  String desc;
  VoidCallback onClick;
  String bttnText;
  String modelImage;
  double left;
  double bottom;

  Cards({
    super.key,
    required this.mainImage,
    required this.height,
    required this.width,
    required this.title,
    required this.desc,
    required this.onClick,
    required this.bttnText,
    required this.modelImage,
    required this.left,
    required this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              mainImage,
              height: 170.h,
              width: 300.w,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            child: Stack(
              children: [
                Container(
                  height: 170.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(0xFF08EBE2).withOpacity(0.6),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    height: 100.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.black.withOpacity(.7)),
                    child: Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Divider(
                            color: Colors.white,
                            indent: 30,
                            endIndent: 30,
                            height: 8,
                          ),
                          Text(
                            desc,
                            // textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Image.asset(
                    'assets/images/design1.png',
                    width: 370,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    onPressed: onClick,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          bttnText,
                          style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: Colors.white,
                          weight: 5,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: left,
                  top: bottom,
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: Image.asset(
                      modelImage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
