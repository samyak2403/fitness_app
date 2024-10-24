import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineItems extends StatefulWidget {
  final bool isFirst;
  final bool islast;
  final String title;
  final String title2;
  const TimeLineItems({
    super.key,
    required this.isFirst,
    required this.islast,
    required this.title,
    required this.title2,
  });

  @override
  State<TimeLineItems> createState() => _TimeLineItemsState();
}

class _TimeLineItemsState extends State<TimeLineItems> {
  bool isTap = true;
  @override
  void initState() {
    isTap = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
        isFirst: widget.isFirst,
        isLast: widget.islast,
        afterLineStyle:
            const LineStyle(thickness: 2, color: const Color(0xFF08EBE2)),
        beforeLineStyle:
            const LineStyle(thickness: 2, color: const Color(0xFF08EBE2)),
        indicatorStyle: IndicatorStyle(
            iconStyle:
                IconStyle(iconData: Icons.circle_outlined, color: Colors.white),
            color: const Color(0xFF08EBE2),
            width: 25.w),
        endChild: Padding(
            padding: EdgeInsets.all(10.w),
            child: InkWell(
              onTap: () {
                setState(() {
                  isTap = false;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    widget.title2,
                    style: GoogleFonts.ubuntu(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            )));
  }
}
