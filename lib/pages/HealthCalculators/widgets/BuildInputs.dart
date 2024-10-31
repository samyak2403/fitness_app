import 'package:fitness_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildInputs extends StatefulWidget {
  final String selectedCalculator;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController ageController;
  String gender;

  BuildInputs({
    super.key,
    required this.selectedCalculator,
    required this.heightController,
    required this.weightController,
    required this.ageController,
    required this.gender,
  });

  @override
  State<BuildInputs> createState() => _BuildInputsState();
}

class _BuildInputsState extends State<BuildInputs> {
  @override
  void initState() {
    super.initState();
    widget.gender = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedCalculator == null) return Container();

    return Column(
      children: [
        Divider(),
        SizedBox(
          height: 20.h,
        ),

        // Height Input (Always Required)
        TextField(
          keyboardType: TextInputType.number,
          controller: widget.heightController,
          cursorColor: ColorTemplates.textClr,
          decoration: InputDecoration(
            hintText: 'Enter Height',
            hintStyle: GoogleFonts.ubuntu(
                color: Colors.black.withOpacity(.5),
                fontWeight: FontWeight.w600),
            labelText: 'Height (in cm)',
            labelStyle: GoogleFonts.ubuntu(
                color: Colors.black, fontWeight: FontWeight.w800),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide:
                    BorderSide(color: const Color(0xFF01FBE2), width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.black, width: 1)),
          ),
        ),
        SizedBox(height: 20.h),

        // Weight Input (Always Required)
        TextField(
          keyboardType: TextInputType.number,
          controller: widget.weightController,
          cursorColor: ColorTemplates.textClr,
          decoration: InputDecoration(
            hintText: 'Enter Weight',
            hintStyle: GoogleFonts.ubuntu(
                color: Colors.black.withOpacity(.5),
                fontWeight: FontWeight.w600),
            labelText: 'Weight (in kg)',
            labelStyle: GoogleFonts.ubuntu(
                color: Colors.black, fontWeight: FontWeight.w800),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide:
                    BorderSide(color: const Color(0xFF01FBE2), width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.black, width: 1)),
          ),
        ),

        // Conditionally Show Age and Gender based on selected calculator
        if (widget.selectedCalculator == 'BMR (Basal Metabolic Rate)' ||
            widget.selectedCalculator == 'IBW (Ideal Body Weight)') ...[
          SizedBox(height: 20.h),

          TextField(
            controller: widget.ageController,
            keyboardType: TextInputType.number,
            cursorColor: ColorTemplates.textClr,
            decoration: InputDecoration(
              hintText: 'Enter Age',
              hintStyle: GoogleFonts.ubuntu(
                  color: Colors.black.withOpacity(.5),
                  fontWeight: FontWeight.w600),
              labelText: 'Age',
              labelStyle: GoogleFonts.ubuntu(
                  color: Colors.black, fontWeight: FontWeight.w800),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                      BorderSide(color: const Color(0xFF01FBE2), width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.black, width: 1)),
            ),
          ),
          SizedBox(height: 20.h),
          // Gender Input
          Row(
            children: [
              Text(
                'Gender:',
                style: GoogleFonts.ubuntu(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Radio(
                  activeColor: const Color(0xFF01FBE2),
                  value: 'Male',
                  groupValue: widget.gender,
                  onChanged: (value) {
                    setState(() {
                      widget.gender = value.toString();
                    });
                  }),
              const Text('Male'),
              Radio(
                  activeColor: const Color(0xFF01FBE2),
                  value: 'Female',
                  groupValue: widget.gender,
                  onChanged: (value) {
                    setState(() {
                      widget.gender = value.toString();
                    });
                  }),
              const Text('Female'),
            ],
          ),
        ],
      ],
    );
  }
}
