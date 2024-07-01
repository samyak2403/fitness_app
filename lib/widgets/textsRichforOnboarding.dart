import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextRich extends StatelessWidget {
  final String txt1;
  final Color txtClr1;
  final FontWeight fontWt1;
  final double fontSZ1;
  final String txt2;
  final Color txtClr2;
  final FontWeight fontWt2;
  final double fontSZ2;
  final String? txt3;
  final Color? txtClr3;
  final FontWeight? fontWt3;
  final double? fontSZ3;
  const TextRich({
    super.key,
    required this.txt1,
    required this.txtClr1,
    required this.fontWt1,
    required this.fontSZ1,
    required this.txt2,
    required this.txtClr2,
    required this.fontWt2,
    required this.fontSZ2,
    this.txt3,
    this.txtClr3,
    this.fontWt3,
    this.fontSZ3,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: txt1,
        style: GoogleFonts.ubuntu(
            color: txtClr1, fontWeight: fontWt1, fontSize: fontSZ1),
        children: [
          TextSpan(
            text: txt2,
            style: GoogleFonts.ubuntu(
                color: txtClr2, fontWeight: fontWt2, fontSize: fontSZ2),
          ),
          TextSpan(
            text: txt3,
            style: GoogleFonts.ubuntu(
                color: txtClr3, fontWeight: fontWt3, fontSize: fontSZ3),
          )
        ],
      ),
    );
  }
}
