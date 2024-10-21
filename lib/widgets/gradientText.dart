import 'package:fitness_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Gradienttext extends StatefulWidget {
  final String txt;
  final FontWeight fontWt;
  final double fontSz;
  const Gradienttext(
      {super.key,
      required this.txt,
      required this.fontWt,
      required this.fontSz});

  @override
  State<Gradienttext> createState() => _GradienttextState();
}

class _GradienttextState extends State<Gradienttext> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: ShaderMask(
        child: Text(
          widget.txt,
          textAlign: TextAlign.center,
          style: GoogleFonts.ubuntu(
              color: ColorTemplates.primary,
              fontSize: widget.fontSz,
              fontWeight: widget.fontWt),
        ),
        shaderCallback: (rect) {
          return const LinearGradient(stops: [
            0.3,
            0.8,
            0.9
          ], colors: [
            Color.fromARGB(255, 193, 177, 237),
            Color.fromARGB(255, 143, 113, 227),
            Color.fromARGB(255, 104, 62, 220)
          ]).createShader(rect);
        },
      ),
    ));
  }
}
