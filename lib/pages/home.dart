import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/pages/AuthScreens/login.dart';
import 'package:fitness_app/services/services.dart';
import 'package:fitness_app/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void _logout() async {
    try {
      await ref.read(authServiceProvider).signOut();
      changeScreenRemoveUntil(
          context, SignInScreen(), PageTransitionType.leftToRightWithFade, 300);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ElevatedButton(onPressed: _logout, child: Text('log out')),
      )),
    );
  }
}
