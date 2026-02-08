import 'package:ai_health/screens/journal.dart';
import 'package:get/get.dart';

import '../screens/profile_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/community_chat.dart';
import '../screens/question_screen.dart';

class AppRoute {
  static const String initial = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String settings = '/settings';
  static const String progress = '/progress';
  static const String community_chat = '/community_chat';
  static const String questions = '/questions';
  static const String journal = '/journal';
  static const String profile = '/profile';

  static final routes = [
    GetPage(name: initial, page: () => const SplashScreen()),
    GetPage(
      name: login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: register,
      page: () => const RegisterScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: questions,
      page: () => const QuestionScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: chat,
      page: () => const ChatScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: settings,
      page: () => const SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: progress,
      page: () => const ProgressScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: community_chat,
      page: () => const CommunityChat(roomId: 'global'),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: journal,
      page: () => JournalScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
