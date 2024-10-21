import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> saveUserHealthData(
    String email, double bmi, double bmr, double hrc) async {
  // Create or update the user document in Firestore
  await FirebaseFirestore.instance.collection('users').doc(email).set({
    'bmi': {
      'value': bmi,
      'date': DateTime.now().toIso8601String(),
    },
    'bmr': {
      'value': bmr,
      'date': DateTime.now().toIso8601String(),
    },
    'hrc': {
      'value': hrc,
      'date': DateTime.now().toIso8601String(),
    },
    'timestamp': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
}
