import 'package:flutter/material.dart';
import 'dart:convert';

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
    'Maintain weight',
    'Improve overall health'
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
        title: const Text('Generate Diet Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Select your health goal:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _healthGoals
                  .map((goal) => ChoiceChip(
                        label: Text(goal),
                        selected: _selectedGoal == goal,
                        onSelected: (selected) {
                          setState(() {
                            _selectedGoal = selected ? goal : null;
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('Select your activity level:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _activityLevels
                  .map((level) => ChoiceChip(
                        label: Text(level),
                        selected: _selectedActivityLevel == level,
                        onSelected: (selected) {
                          setState(() {
                            _selectedActivityLevel = selected ? level : null;
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('Select your age group:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _ageGroups
                  .map((ageGroup) => ChoiceChip(
                        label: Text(ageGroup),
                        selected: _selectedAgeGroup == ageGroup,
                        onSelected: (selected) {
                          setState(() {
                            _selectedAgeGroup = selected ? ageGroup : null;
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Text('Select your gender:',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _genders
                  .map((gender) => ChoiceChip(
                        label: Text(gender),
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
              onPressed: (_selectedGoal != null &&
                      _selectedActivityLevel != null &&
                      _selectedAgeGroup != null &&
                      _selectedGender != null &&
                      !_isLoading)
                  ? _generateDietPlan
                  : null,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Generate Diet Plan'),
            ),
            const SizedBox(height: 24),
            if (_dietPlan != null || _rawResponse != null)
              Expanded(
                child: SingleChildScrollView(
                  child: _buildDietPlanDisplay(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDietPlanDisplay() {
    if (_dietPlan != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Personalized Diet Plan',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 16),
          ..._dietPlan!.entries
              .map((entry) => _buildSection(entry.key, entry.value)),
        ],
      );
    } else if (_rawResponse != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Raw Response (Debug Info):',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
          ),
          const SizedBox(height: 8),
          Text(_rawResponse!),
        ],
      );
    } else {
      return const Text('No diet plan generated yet.');
    }
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

    try {
      // Simulating the API response generation
      final response = jsonEncode({
        "Breakfast": ["Oatmeal with berries", "Greek yogurt with honey"],
        "Lunch": ["Grilled chicken salad", "Quinoa with vegetables"],
        "Dinner": ["Baked salmon with brown rice", "Steamed broccoli"],
        "Snacks": ["Almonds", "Apple slices with peanut butter"]
      });

      setState(() {
        _rawResponse = response;
        _dietPlan = jsonDecode(response);
        _isLoading = false;
      });
    } catch (e) {
      print('Error generating diet plan: $e');
      setState(() {
        _isLoading = false;
        _dietPlan = null;
        _rawResponse = 'Error: $e';
      });
    }
  }
}
