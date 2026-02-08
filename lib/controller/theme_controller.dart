import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void setDarkMode(bool enabled) {
    themeMode.value = enabled ? ThemeMode.dark : ThemeMode.light;
  }
}
