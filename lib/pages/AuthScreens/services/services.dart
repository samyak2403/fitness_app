import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/provider/provider.dart';
import 'package:fitness_app/widgets/scaffoldMessenger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref);
});

class AuthService {
  final Ref _ref;

  AuthService(this._ref);

  FirebaseAuth get _auth => _ref.read(firebaseAuthProvider);

  // void signIn() async {
  //   try {
  //     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text,
  //       password: passwordController.text,
  //     );

  //     User? user = FirebaseAuth.instance.currentUser;

  //     if (user != null && !user.emailVerified) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Please verify your email to log in.'))
  //       );
  //       await FirebaseAuth.instance.signOut(); // Force logout if not verified
  //     } else {
  //       // Proceed with login, user is verified
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to home screen
  //       );
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message.toString())));
  //   }
  // }

  // Future<User?> signUp(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     return userCredential.user;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // The user canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the obtained credentials
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Store user info in Firestore
      await _storeUserData(user);

      return user;
    } on FirebaseException catch (e) {
      SnackBarWidget.show(context, e.message!);
      return null;
    }
  }

  Future<void> _storeUserData(User? user) async {
    if (user != null) {
      // Here we can set a default phone number or you can prompt the user to enter it
      String phoneNumber =
          ""; // Set the phone number if available, or prompt for it

      // Create a document for the user using their email
      await FirebaseFirestore.instance
          .collection('userdata')
          .doc(user.email)
          .set({
        'email': user.email,
        'firstname':
            user.displayName?.split(' ')[0] ?? "", // Get the first name
        'phone': phoneNumber, // Save the phone number
        // You can add more fields here if necessary
      });
    }
  }

  Future<void> googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}