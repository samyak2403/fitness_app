import 'dart:async';

import 'package:fitness_app/pages/OnboardingScreens/pages/screen1.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class Functions {
  static Map<String, Map<String, String>> quickworkoutInfo = {
    'Core Crusher': {
      'duration': '15 min',
      'level': 'Beginner',
      'Excercises': '11',
      'calories': '70-80',
      'folder': 'core_crusher'
    },
    'Full Body Workout': {
      'duration': '20 min',
      'level': 'Intermediate',
      'Excercises': '15',
      'calories': '120-130',
      'folder': 'full_body_hiit'
    },
    'Upper Body Strength': {
      'duration': '30 min',
      'level': 'Advanced',
      'Excercises': '20',
      'calories': '150-180',
      'folder': 'upper_body'
    },
  };

  static List<String> collectionName = [
    'Core_Cusher',
    'Full_Body_HIIT',
    'Upper_Body_Strength'
  ];

  static void showSignOutConfirmationDialog(
    BuildContext context,
    Function signout,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Confirm Logout',
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            content: Text(
              'Are you sure you want to log out?',
              style: GoogleFonts.ubuntu(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01FBE2)),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Close the dialog without logging out
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01FBE2)),
                child: Text(
                  'Log out',
                  style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  signout();
                  changeScreenRemoveUntil(context, OnboardingScreen1(),
                      PageTransitionType.leftToRight, 200);
                },
              ),
            ],
          );
        });
  }

  static void startAutoScroll(ScrollController scrollController, Timer timer) {
    double _scrollOffset = 0.0;
    double _scrollStep = 370.0; // Distance to scroll each time
    bool _scrollingForward = true;
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (scrollController.hasClients) {
        // Get the max scroll extent (i.e., the end of the scroll view)
        final maxScrollExtent = scrollController.position.maxScrollExtent;

        // Check if we are at the end or the start, and adjust direction
        if (_scrollOffset >= maxScrollExtent) {
          _scrollingForward = false; // Reverse direction
        } else if (_scrollOffset <= 0) {
          _scrollingForward = true; // Scroll forward again
        }

        // Update the offset for the next scroll
        _scrollOffset += _scrollingForward ? _scrollStep : -_scrollStep;

        // Ensure the offset is within bounds
        _scrollOffset = _scrollOffset.clamp(0.0, maxScrollExtent);

        // Animate the scroll
        scrollController.animateTo(
          _scrollOffset,
          duration: const Duration(seconds: 1), // Scroll duration
          curve: Curves.easeInOut, // Smooth scroll effect
        );
      }
    });
  }
}
