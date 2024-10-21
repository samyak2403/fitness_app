import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ElevatedIconBttn extends StatelessWidget {
  final double maxWidth;
  final double maxHeigth;
  final double width;
  final Color bgClr;
  final Color txtClr;
  final double elevationValue;
  final String txt;
  final FontWeight fontWt;
  final double fontSz;
  final IconData ikon;
  final MainAxisAlignment mainaxisAlignment;
  final Color iconClr;
  final double iconSz;
  final VoidCallback onClick;
  // final bool? isLoading;
  ElevatedIconBttn({
    super.key,
    required this.maxWidth,
    required this.maxHeigth,
    required this.elevationValue,
    required this.txt,
    required this.fontWt,
    required this.fontSz,
    required this.ikon,
    required this.bgClr,
    required this.mainaxisAlignment,
    required this.txtClr,
    required this.iconClr,
    required this.iconSz,
    required this.onClick,
    required this.width,
    // required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    return
        // isLoading!
        //     ? Container(
        //         height: 35.h,
        //         width: 320.w,
        //         decoration: BoxDecoration(
        //             color: ColorTemplates.buttonClr,
        //             borderRadius: BorderRadius.circular(20),
        //             boxShadow: [
        //               BoxShadow(
        //                 offset: Offset(0, 3),
        //                 blurRadius: 3.r,
        //                 color: ColorTemplates.textClr.withOpacity(.4.w),
        //               )
        //             ]),
        //         child: const Center(
        //             child: CircularProgressIndicator(
        //           backgroundColor: ColorTemplates.primary,
        //           color: ColorTemplates.textClr,
        //         )),
        //       )
        //     :
        ElevatedButton(
      style: ElevatedButton.styleFrom(
        maximumSize: Size(maxWidth, maxHeigth),
        backgroundColor: bgClr,
        elevation: elevationValue,
      ),
      onPressed:
          // isLoading! ? null :
          onClick,
      child: Row(
        mainAxisAlignment: mainaxisAlignment,
        children: [
          Text(
            txt,
            style: GoogleFonts.ubuntu(
                color: txtClr, fontWeight: fontWt, fontSize: fontSz),
          ),
          SizedBox(
            width: width,
          ),
          Icon(
            ikon,
            color: iconClr,
            size: iconSz,
          )
        ],
      ),
    );
  }
}
