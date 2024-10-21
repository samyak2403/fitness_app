import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/firebase_options.dart';
import 'package:fitness_app/pages/AuthScreens/pages/authChecker.dart';
import 'package:fitness_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(apiKey: api_key);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (_, child) =>
          MaterialApp(debugShowCheckedModeBanner: false, home: AuthChecker()),
    );
  }
}
