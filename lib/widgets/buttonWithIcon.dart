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
  const ElevatedIconBttn(
      {super.key,
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
      required this.width});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        maximumSize: Size(maxWidth, maxHeigth),
        backgroundColor: bgClr,
        elevation: elevationValue,
      ),
      onPressed: onClick,
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
