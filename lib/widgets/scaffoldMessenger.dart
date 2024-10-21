import 'package:fitness_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackBarWidget {
  static void show(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: ColorTemplates.textClr,
        content: Text(
          message,
          style: GoogleFonts.ubuntu(
              color: ColorTemplates.primary, fontWeight: FontWeight.w500),
        ),
        duration: duration,
      ),
    );
  }
}
