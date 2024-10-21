import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HealthCalculatorsScreen extends StatefulWidget {
  final String userEmail; // Assume you pass the user's email here

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
        title: const Text('Health Calculators'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Select a calculator:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _calculators
                  .map((calculator) => ChoiceChip(
                        label: Text(calculator),
                        selected: _selectedCalculator == calculator,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCalculator = selected ? calculator : null;
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            _buildInputFields(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: (_selectedCalculator != null && !_isLoading)
                  ? _calculateResult
                  : null,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Calculate'),
            ),
            const SizedBox(height: 24),
            if (_result != null) _buildResultDisplay(),
            const SizedBox(height: 24),
            if (_bmi != null && _bmr != null && _hrc != null) ...[
              Text('BMI: ${_bmi!.toStringAsFixed(2)}'),
              Text('BMR: ${_bmr!.toStringAsFixed(2)}'),
              Text('HRC: ${_hrc!.toStringAsFixed(2)}'),
              Text(
                  'Overall Health Percentage: ${_calculateOverallHealthPercentage()}%'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    if (_selectedCalculator == null) return Container();

    return Column(
      children: [
        TextField(
          controller: _heightController,
          decoration: InputDecoration(labelText: 'Height (in cm)'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _weightController,
          decoration: InputDecoration(labelText: 'Weight (in kg)'),
          keyboardType: TextInputType.number,
        ),
        if (_selectedCalculator == 'BMR (Basal Metabolic Rate)' ||
            _selectedCalculator == 'IBW (Ideal Body Weight)') ...[
          const SizedBox(height: 16),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(labelText: 'Age'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Gender:'),
              Radio(
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value.toString();
                    });
                  }),
              const Text('Male'),
              Radio(
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value.toString();
                    });
                  }),
              const Text('Female'),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildResultDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Result: ${_result!.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        if (_classificationMessage != null) ...[
          const SizedBox(height: 16),
          Text(
            _classificationMessage!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
          ),
        ],
      ],
    );
  }

  void _calculateResult() {
    setState(() {
      _isLoading = true;
    });

    final double height = double.tryParse(_heightController.text) ?? 0.0;
    final double weight = double.tryParse(_weightController.text) ?? 0.0;
    final int age = int.tryParse(_ageController.text) ?? 0;

    double? bmr;
    double? hrc;

    switch (_selectedCalculator) {
      case 'BMI (Body Mass Index)':
        _result = _calculateBMI(height, weight);
        _classificationMessage = _classifyBMI(_result!);
        break;
      case 'BMR (Basal Metabolic Rate)':
        _result = _calculateBMR(height, weight, age, _gender);
        _classificationMessage = 'BMR is your daily calorie requirement.';
        bmr = _result; // Store BMR value
        break;
      case 'IBW (Ideal Body Weight)':
        _result = calculateIBW(height, _gender);
        _classificationMessage = 'This is your ideal body weight.';
        break;
      case 'HRC (Heart Rate Calculator)':
        hrc = _calculateHRC(age);
        _result = hrc; // Store HRC value
        _classificationMessage = _classifyHRC(hrc);
        break;
      default:
        _result = null;
    }

    // Save the data to Firestore after calculating the results
    if (_result != null) {
      if (_selectedCalculator == 'BMI (Body Mass Index)') {
        saveBMIDate(widget.userEmail, _result!);
      } else if (_selectedCalculator == 'BMR (Basal Metabolic Rate)') {
        saveBMRDate(widget.userEmail, _result!);
      } else if (_selectedCalculator == 'HRC (Heart Rate Calculator)') {
        saveHRCDate(widget.userEmail, _result!);
      }
    }

    // Calculate and store overall health percentage
    double overallHealthPercentage = _calculateOverallHealthPercentage();
    saveOverallHealthPercentage(widget.userEmail, overallHealthPercentage);

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
    return 220 - age.toDouble(); // Maximum heart rate
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

    // Use set with merge to avoid overwriting existing data
    FirebaseFirestore.instance.collection('users').doc(email).set(
        {
          'OverallHealthPercentage': {
            'value': double.parse(formattedPercentage),
            'updated_time':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          },
        },
        SetOptions(
            merge: true)); // This will create the document if it doesn't exist
  }

  void saveHealthData(String email, String type, double value) {
    // Use set with merge to avoid overwriting existing data
    FirebaseFirestore.instance.collection('users').doc(email).set(
        {
          '$type': {
            'value': value,
            'updated_time':
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
          },
        },
        SetOptions(
            merge: true)); // This will create the document if it doesn't exist
  }

  double _calculateOverallHealthPercentage() {
    double bmiScore =
        (_bmi! >= 18.5 && _bmi! <= 24.9) ? 100 : 0; // Ideal BMI range
    double bmrScore =
        (_bmr! >= 1200 && _bmr! <= 2500) ? 100 : 0; // Example BMR range
    double hrcScore =
        (_hrc! >= 60 && _hrc! <= 100) ? 100 : 0; // Normal heart rate range

    // Average score
    return (bmiScore + bmrScore + hrcScore) / 3;
  }
}
