import 'package:fitness_app/pages/HealthCalculators/widgets/BuildInputs.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HealthCalculatorsScreen extends StatefulWidget {
  final String userEmail;

  const HealthCalculatorsScreen({Key? key, required this.userEmail})
      : super(key: key);

  @override
  _HealthCalculatorsScreenState createState() =>
      _HealthCalculatorsScreenState();
}

class _HealthCalculatorsScreenState extends State<HealthCalculatorsScreen> {
  String? _selectedCalculator;
  bool _isLoading = false;
  double? _result;
  String? _classificationMessage;

  double? _bmi;
  double? _bmr;
  double? _hrc;

  final List<String> _calculators = [
    'BMI (Body Mass Index)',
    'BMR (Basal Metabolic Rate)',
    'IBW (Ideal Body Weight)',
    'HRC (Heart Rate Calculator)',
  ];

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _gender = 'Male';

  @override
  void initState() {
    super.initState();
    _selectedCalculator = 'BMI (Body Mass Index)';
    _getUserHealthData();
  }

  Future<void> _getUserHealthData() async {
    Map<String, dynamic>? healthData =
        await fetchUserHealthData(widget.userEmail);
    if (healthData != null) {
      setState(() {
        _bmi = healthData['BMI']['value'] ?? 0.0;
        _bmr = healthData['BMR']['value'] ?? 0.0;
        _hrc = healthData['HRC']['value'] ?? 0.0;
      });
    }
  }

  Future<Map<String, dynamic>?> fetchUserHealthData(String email) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print('Error fetching health data: $e');
    }
    return null;
  }

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
          'Health Calculators',
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontSize: 20,
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
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Select a calculator :',
                    style: GoogleFonts.ubuntu(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _calculators
                        .map((calculator) => ChoiceChip(
                              backgroundColor: Colors.black,
                              selectedColor: const Color(0xFF01FBE2),
                              label: Text(
                                calculator,
                                style: GoogleFonts.ubuntu(
                                  color: _selectedCalculator == calculator
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              selected: _selectedCalculator == calculator,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCalculator =
                                      selected ? calculator : null;
                                  _result = null;
                                  _classificationMessage = null;
                                });
                              },
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  BuildInputs(
                      selectedCalculator: _selectedCalculator!,
                      heightController: _heightController,
                      weightController: _weightController,
                      ageController: _ageController,
                      gender: _gender),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      disabledBackgroundColor: Colors.black54,
                      backgroundColor: Colors.black,
                      minimumSize: Size(300.w, 40.h),
                    ),
                    onPressed: (_selectedCalculator != null && !_isLoading)
                        ? _calculateResult
                        // Trigger BMI calculation
                        : null,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xFF01FBE2),
                          )
                        : Text(
                            'Calculate',
                            style: GoogleFonts.ubuntu(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  SizedBox(height: 20.h),
                  if (_result != null) _buildResultDisplay(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Result: ${_result!.toStringAsFixed(2)}',
          style: GoogleFonts.ubuntu(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (_classificationMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            _classificationMessage!,
            style: GoogleFonts.ubuntu(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }

  void _calculateResult() {
    setState(() {
      _isLoading = true;
      _result = null;
      _classificationMessage = null;
    });

    final double height = double.tryParse(_heightController.text) ?? 0.0;
    final double weight = double.tryParse(_weightController.text) ?? 0.0;

    if (height == 0 || weight == 0) {
      setState(() {
        _isLoading = false;
        _classificationMessage = "Please enter valid height and weight.";
      });
      return;
    }

    double? bmr;
    double? hrc;

    switch (_selectedCalculator) {
      case 'BMI (Body Mass Index)':
        _result = _calculateBMI(height, weight);
        _classificationMessage = _classifyBMI(_result!);

        // Save BMI to Firebase
        saveBMIDate(widget.userEmail, _result!);
        break;

      case 'BMR (Basal Metabolic Rate)':
        final int age = int.tryParse(_ageController.text) ?? 0;
        if (age <= 0) {
          setState(() {
            _isLoading = false;
            _classificationMessage = "Please enter a valid age.";
          });
          return;
        }
        _result = _calculateBMR(height, weight, age, _gender);
        _classificationMessage = 'BMR is your daily calorie requirement.';

        // Save BMR to Firebase
        saveBMRDate(widget.userEmail, _result!);
        break;

      case 'IBW (Ideal Body Weight)':
        _result = calculateIBW(height, _gender);
        _classificationMessage = 'This is your ideal body weight.';
        // IBW can be stored similarly if needed.
        break;

      case 'HRC (Heart Rate Calculator)':
        final int age = int.tryParse(_ageController.text) ?? 0;
        if (age <= 0) {
          setState(() {
            _isLoading = false;
            _classificationMessage = "Please enter a valid age.";
          });
          return;
        }
        hrc = _calculateHRC(age);
        _result = hrc;
        _classificationMessage = _classifyHRC(hrc);

        saveHRCDate(widget.userEmail, hrc);
        break;

      default:
        _result = null;
    }

    if (_bmi != null && _bmr != null && _hrc != null) {
      double overallHealthPercentage = _calculateOverallHealthPercentage();
      saveOverallHealthPercentage(widget.userEmail, overallHealthPercentage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  double _calculateBMI(double height, double weight) {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  String _classifyBMI(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight: Consider gaining some weight.';
    } else if (bmi >= 18.5 && bmi <= 24.9) {
      return 'Normal weight: Keep up the healthy lifestyle!';
    } else if (bmi >= 25 && bmi <= 29.9) {
      return 'Overweight: Consider losing some weight.';
    } else {
      return 'Obesity: Consult a doctor for weight management.';
    }
  }

  double _calculateBMR(double height, double weight, int age, String gender) {
    if (gender == 'Male') {
      return 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      return 10 * weight + 6.25 * height - 5 * age - 161;
    }
  }

  double calculateIBW(double height, String gender) {
    if (gender == 'Male') {
      return 50 + 0.91 * (height - 152.4);
    } else {
      return 45.5 + 0.91 * (height - 152.4);
    }
  }

  double _calculateHRC(int age) {
    return 220 - age.toDouble();
  }

  String _classifyHRC(double hrc) {
    if (hrc < 60) {
      return 'Low heart rate. Consult a doctor.';
    } else if (hrc >= 60 && hrc <= 100) {
      return 'Normal heart rate. Keep it up!';
    } else {
      return 'High heart rate. Consult a doctor.';
    }
  }

  double calculateBMIScore(double bmi) {
    double score;
    if (bmi >= 18.5 && bmi <= 24.9) {
      score = 100;
    } else if (bmi < 18.5) {
      score = 100 - ((18.5 - bmi) * 10);
    } else {
      score = 100 - ((bmi - 24.9) * 10);
    }
    return score.clamp(0, 100);
  }

  double calculateBMRScore(double bmr) {
    double score;
    if (bmr >= 1200 && bmr <= 2500) {
      score = 100;
    } else if (bmr < 1200) {
      score = 100 - ((1200 - bmr) * 0.05);
    } else {
      score = 100 - ((bmr - 2500) * 0.05);
    }
    return score.clamp(0, 100);
  }

  double calculateHRCScore(double hrc) {
    double score;
    if (hrc >= 60 && hrc <= 100) {
      score = 100;
    } else if (hrc < 60) {
      score = 100 - ((60 - hrc) * 2);
    } else {
      score = 100 - ((hrc - 100) * 2);
    }
    return score.clamp(0, 100);
  }

  void saveBMIDate(String email, double bmi) {
    saveHealthData(email, 'BMI', bmi);
  }

  void saveBMRDate(String email, double bmr) {
    saveHealthData(email, 'BMR', bmr);
  }

  void saveHRCDate(String email, double hrc) {
    saveHealthData(email, 'HRC', hrc);
  }

  void saveOverallHealthPercentage(
      String email, double overallHealthPercentage) {
    String formattedPercentage = overallHealthPercentage.toStringAsFixed(2);

    FirebaseFirestore.instance.collection('users').doc(email).set({
      'OverallHealthPercentage': {
        'value': double.parse(formattedPercentage),
        'updated_time':
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      },
    }, SetOptions(merge: true));
  }

  void saveHealthData(String email, String type, double value) {
    FirebaseFirestore.instance.collection('users').doc(email).set({
      '$type': {
        'value': value,
        'updated_time':
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      },
    }, SetOptions(merge: true));
  }

  double _calculateOverallHealthPercentage() {
    double bmiScore = (_bmi != null) ? calculateBMIScore(_bmi!) : 0.0;
    double bmrScore = (_bmr != null) ? calculateBMRScore(_bmr!) : 0.0;
    double hrcScore = (_hrc != null) ? calculateHRCScore(_hrc!) : 0.0;

    return (bmiScore + bmrScore + hrcScore) / 3;
  }
}
