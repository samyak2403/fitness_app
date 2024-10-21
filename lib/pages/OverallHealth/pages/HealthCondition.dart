// double _calculateOverallHealth(double bmi, double bmr, double hrc) {
//   double bmiScore = _normalizeBMI(bmi);
//   double bmrScore = _normalizeBMR(bmr);
//   double hrcScore = _normalizeHRC(hrc);

//   // Average the scores to get overall health percentage
//   return ((bmiScore + bmrScore + hrcScore) / 3) * 100;  // 0-100 scale
// }

// double _normalizeBMI(double bmi) {
//   // Example normalization
//   if (bmi < 18.5) {
//     return 40; // Underweight
//   } else if (bmi >= 18.5 && bmi <= 24.9) {
//     return 100; // Healthy weight
//   } else if (bmi >= 25 && bmi <= 29.9) {
//     return 70; // Overweight
//   } else {
//     return 30; // Obese
//   }
// }

// double _normalizeBMR(double bmr) {
//   // Normalize based on general BMR values for adults
//   if (bmr < 1200) {
//     return 50; // Low BMR
//   } else if (bmr >= 1200 && bmr <= 2000) {
//     return 100; // Normal BMR
//   } else {
//     return 75; // High BMR
//   }
// }

// double _normalizeHRC(double hrc) {
//   // Normalize heart rate based on general resting heart rate
//   if (hrc < 60) {
//     return 70; // Good fitness level
//   } else if (hrc >= 60 && hrc <= 100) {
//     return 100; // Normal range
//   } else {
//     return 50; // High heart rate
//   }
// }

// Widget _buildOverallHealthDisplay(double overallHealth) {
//   String classification;
//   if (overallHealth >= 90) {
//     classification = "Excellent health!";
//   } else if (overallHealth >= 70) {
//     classification = "Good health!";
//   } else if (overallHealth >= 50) {
//     classification = "Fair health, consider lifestyle changes.";
//   } else {
//     classification = "Poor health, consult a healthcare provider.";
//   }

//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'Overall Body Health: ${overallHealth.toStringAsFixed(2)}%',
//         style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).primaryColor,
//             ),
//       ),
//       Text(
//         classification,
//         style: TextStyle(
//           color: overallHealth < 70 ? Colors.red : Colors.green,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ],
//   );
// }
