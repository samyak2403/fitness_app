import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// class LoadingStateNotifier extends StateNotifier<bool> {
//   LoadingStateNotifier() : super(false);

//   void setLoading(bool isLoading) => state = isLoading;
// }

// final loadingProvider = StateProvider.autoDispose<bool>((ref) => false);
