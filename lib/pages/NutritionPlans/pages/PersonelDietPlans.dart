import 'package:fitness_app/pages/NutritionPlans/pages/DietPlanScreen.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class GenerateDietPlanScreen extends StatefulWidget {
  const GenerateDietPlanScreen({Key? key}) : super(key: key);

  @override
  _GenerateDietPlanScreenState createState() => _GenerateDietPlanScreenState();
}

class _GenerateDietPlanScreenState extends State<GenerateDietPlanScreen> {
  String? _selectedGoal;
  String? _selectedActivityLevel;
  String? _selectedAgeGroup;
  String? _selectedGender;
  bool _isLoading = false;
  String? _rawResponse;
  Map<String, dynamic>? _dietPlan;

  final List<String> _healthGoals = [
    'Lose weight',
    'Build muscle',
    'Improve cardiovascular health',
    'Enhance overall fitness'
  ];

  final List<String> _activityLevels = [
    'Sedentary',
    'Lightly active',
    'Moderately active',
    'Very active'
  ];

  final List<String> _ageGroups = ['18-29', '30-49', '50-65', '65+'];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 15.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Generate Diet Plan',
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select your health goal:',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Divider(
                    height: 20.h,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _healthGoals
                        .map((goal) => Container(
                              child: Row(
                                children: [
                                  Container(
                                    height: 30.h,
                                    width: 30.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          selectedColor:
                                              const Color(0xFF01FBE2),
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
                  const SizedBox(height: 16),
                  Text(
                    'Select your activity level:',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Divider(
                    height: 20.h,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _activityLevels
                        .map((level) => ChoiceChip(
                              backgroundColor: Colors.black,
                              selectedColor: const Color(0xFF01FBE2),
                              label: Text(
                                level,
                                style: GoogleFonts.ubuntu(
                                  color: _selectedActivityLevel == level
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              selected: _selectedActivityLevel == level,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedActivityLevel =
                                      selected ? level : null;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select your age group:',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Divider(
                    height: 20.h,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _ageGroups
                        .map((ageGroup) => ChoiceChip(
                              backgroundColor: Colors.black,
                              selectedColor: const Color(0xFF01FBE2),
                              label: Text(
                                ageGroup,
                                style: GoogleFonts.ubuntu(
                                  color: _selectedAgeGroup == ageGroup
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              selected: _selectedAgeGroup == ageGroup,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedAgeGroup =
                                      selected ? ageGroup : null;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select your gender:',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Divider(
                    height: 20.h,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _genders
                        .map((gender) => ChoiceChip(
                              backgroundColor: Colors.black,
                              selectedColor: const Color(0xFF01FBE2),
                              label: Text(
                                gender,
                                style: GoogleFonts.ubuntu(
                                  color: _selectedGender == gender
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              selected: _selectedGender == gender,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedGender = selected ? gender : null;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.black54,
                        backgroundColor: Colors.black,
                        minimumSize: Size(300.w, 40.h)),
                    onPressed: (_selectedGoal != null &&
                            _selectedActivityLevel != null &&
                            _selectedAgeGroup != null &&
                            _selectedGender != null &&
                            !_isLoading)
                        ? _generateDietPlan
                        : null,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: const Color(0xFF01FBE2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Generate Diet Plan',
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
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, dynamic content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (content is List)
              ...content.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(item.toString()),
                  ))
            else
              Text(content.toString()),
          ],
        ),
      ),
    );
  }

  Future<void> _generateDietPlan() async {
    setState(() {
      _isLoading = true;
      _dietPlan = null;
      _rawResponse = null;
    });

    final gemini = Gemini.instance;
    try {
      final response = await gemini.text(
          "Generate a personalized diet plan for someone with the goal of $_selectedGoal, "
          "activity level: $_selectedActivityLevel, age group: $_selectedAgeGroup, and gender: $_selectedGender. "
          "The diet plan should include: 1. Breakfast 2. Lunch 3. Dinner 4. Snacks. "
          "Format the response as a JSON object with these keys: breakfast, lunch, dinner, snacks. "
          "For each meal, provide an array of strings representing the food items. "
          "Avoid using the symbols \"\" and '' in the output. "
          "Example format: "
          "{"
          "  \"Breakfast\": [\"Food 1\", \"Food 2\"],"
          "  \"Lunch\": [\"Food 1\", \"Food 2\"],"
          "  \"Dinner\": [\"Food 1\", \"Food 2\"],"
          "  \"Snacks\": [\"Snack 1\", \"Snack 2\"]"
          "}");

      if (response?.output != null) {
        print("Raw Gemini response:");
        print(response!.output);
        setState(() {
          _rawResponse = response.output;
          _dietPlan = _parseDietPlan(response.output!);
          _isLoading = false;
        });
        if (_dietPlan != null) {
          changeScreen(context, DietPlanDisplayScreen(dietPlan: _dietPlan!),
              PageTransitionType.leftToRight, 200);
        } else {
          throw Exception('No output from Gemini');
        }
      }
    } catch (e) {
      print('Error generating diet plan: $e');
      setState(() {
        _isLoading = false;
        _dietPlan = null;
        _rawResponse = 'Error: $e';
      });
    }
  }

  Map<String, dynamic> _parseDietPlan(String text) {
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
      return _parseDietText(text);
    }
  }

  Map<String, dynamic> _processJsonResponse(Map<String, dynamic> jsonResponse) {
    // Process each section of the workout plan
    ['Breakfast', 'Lunch', 'Dinner', 'Snacks'].forEach((key) {
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

  Map<String, dynamic> _parseDietText(String text) {
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
