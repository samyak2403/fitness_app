import 'package:fitness_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TxtField extends StatefulWidget {
  bool obscure;
  bool visible;
  final double leftPad;
  final double rightPad;
  final double topPad;
  final double bottomPad;
  final TextEditingController controllername;
  final IconData prefixikon;
  final Color prefixikonClr;
  final Color suffixikonClr;
  final String? txt;
  final Color? txtClr;
  final FontWeight? fontWt;
  final String? hintTxt;
  final Color? hintTxtClr;
  final FontWeight? hintFontWt;
  final double focusedboarderrad;
  final Color focusedClr;
  final double focusedboarderwidth;
  final double enabledboarderrad;
  final Color enabledClr;
  final double enabledboarderwidth;
  final TextInputType keyboardType;

  TxtField(
      {super.key,
      required this.controllername,
      required this.prefixikon,
      required this.prefixikonClr,
      this.txt,
      this.txtClr,
      this.fontWt,
      required this.focusedboarderrad,
      required this.focusedClr,
      required this.focusedboarderwidth,
      required this.enabledboarderrad,
      required this.enabledClr,
      required this.enabledboarderwidth,
      required this.leftPad,
      required this.rightPad,
      required this.topPad,
      required this.bottomPad,
      required this.obscure,
      required this.visible,
      required this.suffixikonClr,
      required this.keyboardType,
      this.hintTxt,
      this.hintTxtClr,
      this.hintFontWt});

  @override
  State<TxtField> createState() => _TxtFieldState();
}

class _TxtFieldState extends State<TxtField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.leftPad,
          right: widget.rightPad,
          top: widget.topPad,
          bottom: widget.bottomPad),
      child: TextField(
        keyboardType: widget.keyboardType,
        obscureText: widget.obscure,
        controller: widget.controllername,
        cursorColor: ColorTemplates.textClr,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.prefixikon,
            color: widget.prefixikonClr,
          ),
          suffixIcon: Visibility(
            visible: widget.visible,
            child: IconButton(
              onPressed: () => setState(() {
                widget.obscure = !widget.obscure;
              }),
              icon: Icon(
                widget.obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: widget.suffixikonClr,
              ),
            ),
          ),
          hintText: widget.hintTxt,
          hintStyle: GoogleFonts.ubuntu(
              color: widget.hintTxtClr, fontWeight: widget.hintFontWt),
          labelText: widget.txt,
          labelStyle: GoogleFonts.ubuntu(
              color: widget.txtClr, fontWeight: widget.fontWt),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.focusedboarderrad),
              borderSide: BorderSide(
                  color: widget.focusedClr, width: widget.focusedboarderwidth)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.enabledboarderrad),
              borderSide: BorderSide(
                  color: widget.enabledClr, width: widget.enabledboarderwidth)),
        ),
      ),
    );
  }
}
