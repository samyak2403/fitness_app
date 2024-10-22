import 'package:fitness_app/pages/homeScreen/pages/home.dart';
import 'package:fitness_app/pages/OnboardingScreens/pages/screen1.dart';
import 'package:fitness_app/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthChecker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return HomeScreen();
        } else {
          return OnboardingScreen1();
        }
      },
      loading: () => Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
