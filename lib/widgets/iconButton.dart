import 'package:flutter/material.dart';

class IconBttn extends StatelessWidget {
  final VoidCallback onClick;
  final IconData ikon;
  final Color ikonClr;
  final double ikonSz;
  const IconBttn(
      {super.key,
      required this.onClick,
      required this.ikon,
      required this.ikonClr,
      required this.ikonSz});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onClick,
        icon: Icon(
          ikon,
          color: ikonClr,
          size: ikonSz,
        ));
  }
}
