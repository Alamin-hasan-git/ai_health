import 'package:ai_health/controller/journal_controller.dart';
import 'package:ai_health/screens/splash_screen.dart';
import 'package:ai_health/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/assesment_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Firebase initialized');
  print(FirebaseAuth.instance.currentUser);

  Get.lazyPut(AssessmentController.new, fenix: true);
  Get.lazyPut(JournalController.new, fenix: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AI Health',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      getPages: AppRoute.routes,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF667EEA),
        ),
      ),
    );
  }
}
