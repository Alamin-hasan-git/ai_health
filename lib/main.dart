import 'package:ai_health/screens/splash_screen.dart';
import 'package:ai_health/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
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



