import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void changeScreen(BuildContext context, Widget widget, PageTransitionType type,
    int millisnd) {
  Navigator.push(
    context,
    PageTransition(
        child: widget, type: type, duration: Duration(milliseconds: millisnd)),
  );
}

void changeScreenRepalcement(BuildContext context, Widget widget,
    PageTransitionType type, int millisnd) {
  Navigator.pushReplacement(
    context,
    PageTransition(
        child: widget, type: type, duration: Duration(milliseconds: millisnd)),
  );
}

void changeScreenRemoveUntil(BuildContext context, Widget widget,
    PageTransitionType type, int millisnd) {
  Navigator.pushAndRemoveUntil(
    context,
    PageTransition(
        child: widget, type: type, duration: Duration(milliseconds: millisnd)),
    (Route<dynamic> route) => false,
  );
}
