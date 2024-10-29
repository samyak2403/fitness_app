import 'package:fitness_app/pages/GeneratedWorkOuts/pages/AiWokoutsPage.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class GenerateWorkoutPlanScreen extends StatefulWidget {
  const GenerateWorkoutPlanScreen({Key? key}) : super(key: key);

  @override
  _GenerateWorkoutPlanScreenState createState() =>
      _GenerateWorkoutPlanScreenState();
}

class _GenerateWorkoutPlanScreenState extends State<GenerateWorkoutPlanScreen> {
  String? _selectedGoal;
  String? _selectedExperience;
  bool _isLoading = false;
  String? _rawResponse;
  Map<String, dynamic>? _workoutPlan;

  final List<String> _fitnessGoals = [
    'Lose weight',
    'Build muscle',
    'Improve cardiovascular health',
    'Increase flexibility',
    'Enhance overall fitness'
  ];

  final List<String> _experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 15.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Generate Workout Plan',
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            height: double.infinity,
            width: double.infinity,
            'assets/images/design2.png',
            fit: BoxFit.fitHeight,
            color: const Color(0xFF01FBE2),
          ),
          Positioned(
            bottom: -10,
            right: -10,
            child: Transform.rotate(
              angle: 80,
              child: Image.asset(
                'assets/images/design.png',
                height: 150.h,
                fit: BoxFit.contain,
                color: const Color(0xFF01FBE2).withOpacity(.4),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select your fitness goal:',
                  style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Divider(
                  height: 20.h,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _fitnessGoals
                      .map((goal) => Container(
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.black)),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 30.h,
                                  width: 30.h,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.black)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          'assets/icons/${goal}.png',
                                          scale: 2,
                                          color: _selectedGoal == goal
                                              ? const Color(0xFF01FBE2)
                                              : Colors.black,
                                          fit: BoxFit.cover,
                                          // _selectedGoal == goal
                                          //     ? Colors.black
                                          //     : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Container(
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.black)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ChoiceChip(
                                        backgroundColor: Colors.black,
                                        selectedColor: const Color(0xFF01FBE2),
                                        label: Text(
                                          goal,
                                          style: GoogleFonts.ubuntu(
                                            color: _selectedGoal == goal
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        selected: _selectedGoal == goal,
                                        onSelected: (selected) {
                                          setState(() {
                                            _selectedGoal =
                                                selected ? goal : null;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Select your experience level:',
                  style: GoogleFonts.ubuntu(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Divider(
                  height: 20.h,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _experienceLevels
                      .map((level) => Container(
                            // decoration: BoxDecoration(
                            //     border: Border.all(color: Colors.black)),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 30.h,
                                  width: 30.h,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.black)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Image.asset(
                                          'assets/icons/${level}.png',

                                          scale: 1.5,
                                          color: _selectedExperience == level
                                              ? const Color(0xFF01FBE2)
                                              : Colors.black,

                                          // _selectedGoal == goal
                                          //     ? Colors.black
                                          //     : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Container(
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.black)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ChoiceChip(
                                        backgroundColor: Colors.black,
                                        selectedColor: const Color(0xFF01FBE2),
                                        label: Text(
                                          level,
                                          style: GoogleFonts.ubuntu(
                                            color: _selectedExperience == level
                                                ? Colors.black
                                                : Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        selected: _selectedExperience == level,
                                        onSelected: (selected) {
                                          setState(() {
                                            _selectedExperience =
                                                selected ? level : null;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.black54,
                      backgroundColor: Colors.black,
                      minimumSize: Size(300.w, 40.h)),
                  onPressed: (_selectedGoal != null &&
                          _selectedExperience != null &&
                          !_isLoading)
                      ? _generateWorkoutPlan
                      : null,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xFF01FBE2),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Generate Workout Plan',
                              style: GoogleFonts.ubuntu(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Image.asset(
                              'assets/icons/ai1.png',
                              scale: 5,
                              color: const Color(0xFF01FBE2),
                            )
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateWorkoutPlan() async {
    setState(() {
      _isLoading = true;
      _workoutPlan = null;
      _rawResponse = null;
    });

    final gemini = Gemini.instance;
    try {
      final response = await gemini.text(
          "Generate a structured workout plan for someone with the goal of $_selectedGoal and experience level: $_selectedExperience. "
          "The plan should include: 1. Warm-up exercises 2. Main workout routine 3. Cool-down exercises "
          "Format the response as a JSON object with these keys: warmUp, mainWorkout, coolDown"
          "For exercises and tips, use an array of strings. "
          "and one more thing avoid giving these symbols "
          " and '' this symbols in your output."
          "Example format: "
          "{"
          "  \"Warm-Up\": [\"Exercise 1\", \"Exercise 2\"],"
          "  \"Main Workout\": [\"Exercise 1\", \"Exercise 2\"],"
          "  \"CoolDown\": [\"Exercise 1\", \"Exercise 2\"],"
          "}");

      if (response?.output != null) {
        print("Raw Gemini response:");
        print(response!.output);
        setState(() {
          _rawResponse = response.output;
          _workoutPlan = _parseWorkoutPlan(response.output!);
          _isLoading = false;
        });

        if (_workoutPlan != null) {
          changeScreen(
              context,
              WorkoutPlanDisplayScreen(workoutPlan: _workoutPlan),
              PageTransitionType.leftToRight,
              200);
        }
      } else {
        throw Exception('No output from Gemini');
      }
    } catch (e) {
      print('Error generating workout plan: $e');
      setState(() {
        _isLoading = false;
        _workoutPlan = null;
        _rawResponse = 'Error: $e';
      });
    }
  }

  Map<String, dynamic> _parseWorkoutPlan(String text) {
    // Remove any markdown formatting
    text = text.replaceAll('```json', '').replaceAll('```', '').trim();

    try {
      // Replace problematic number ranges with strings
      text = text.replaceAllMapped(
          RegExp(r':\s*(\d+)-(\d+)([^\d]|$)'),
          (match) =>
              ': "${match.group(1)}-${match.group(2)}"${match.group(3)}');

      // Parse the JSON
      Map<String, dynamic> jsonResponse = jsonDecode(text);
      return _processJsonResponse(jsonResponse);
    } catch (e) {
      print('Error parsing JSON: $e');
      // If JSON parsing fails, fall back to text parsing
      return _parseWorkoutPlanText(text);
    }
  }

  Map<String, dynamic> _processJsonResponse(Map<String, dynamic> jsonResponse) {
    // Process each section of the workout plan
    ['Warm-Up', 'MainWorkout', 'CoolDown'].forEach((key) {
      if (jsonResponse[key] is List) {
        jsonResponse[key] = jsonResponse[key].map((item) {
          if (item is Map) {
            return item.entries.map((e) => "${e.key}: ${e.value}").join(', ');
          }
          return item.toString();
        }).toList();
      }
    });
    return jsonResponse;
  }

  Map<String, dynamic> _parseWorkoutPlanText(String text) {
    final Map<String, dynamic> plan = {};
    String currentSection = '';
    List<String> currentList = [];

    for (var line in text.split('\n')) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.endsWith(':')) {
        if (currentSection.isNotEmpty) {
          plan[currentSection] =
              currentList.isNotEmpty ? currentList : 'No details provided';
          currentList = [];
        }
        currentSection = line.substring(0, line.length - 1);
      } else {
        if (line.startsWith('•') || line.startsWith('-')) {
          currentList.add(line.substring(1).trim());
        } else {
          currentList.add(line);
        }
      }
    }

    if (currentSection.isNotEmpty) {
      plan[currentSection] =
          currentList.isNotEmpty ? currentList : 'No details provided';
    }

    return plan;
  }
}
