import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TxtButton extends StatelessWidget {
  final Color txtClr;
  final String txt;
  final FontWeight fontWt;
  final double fontSz;
  final IconData ikon;
  final MainAxisAlignment mainaxisAlignment;
  final Color iconClr;
  final double iconSz;
  final VoidCallback onClick;
  const TxtButton(
      {super.key,
      required this.txtClr,
      required this.txt,
      required this.fontWt,
      required this.fontSz,
      required this.ikon,
      required this.mainaxisAlignment,
      required this.iconClr,
      required this.iconSz,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Row(
        mainAxisAlignment: mainaxisAlignment,
        children: [
          Text(
            txt,
            style: GoogleFonts.ubuntu(
                color: txtClr, fontWeight: fontWt, fontSize: fontSz),
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
