import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Txt extends StatelessWidget {
  final String txt;
  final double fontSz;
  final FontWeight fontWt;
  final Color txtClr;
  const Txt(
      {super.key,
      required this.txt,
      required this.fontSz,
      required this.fontWt,
      required this.txtClr});

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      textAlign: TextAlign.center,
      style: GoogleFonts.ubuntu(
          color: txtClr, fontWeight: fontWt, fontSize: fontSz),
    );
  }
}
