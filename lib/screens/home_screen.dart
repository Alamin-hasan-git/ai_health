import 'package:ai_health/routes/routes.dart';
import 'package:ai_health/widgets/get_meme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/mood_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F23),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildMoodCard(context),
                const SizedBox(height: 24),
                _buildFeatures(context),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD93D), Color(0xFFFF6B9D)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '😂',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Need a laugh? Check out these memes!',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const MemeListPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: _buildBottomNav(),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
            Color(0xFFEC4899),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: const Text('👋', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Let\'s make today amazing ✨',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E1E3F).withOpacity(0.9),
            const Color(0xFF2D2D5F).withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'MOOD CHECK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodOption('😢', 'Sad', const Color(0xFF3B82F6)),
              _buildMoodOption('😰', 'Anxious', const Color(0xFF8B5CF6)),
              _buildMoodOption('😠', 'Angry', const Color(0xFFEF4444)),
              _buildMoodOption('🫩', 'Tired', const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(String emoji, String label, Color accentColor) {
    return GestureDetector(
      onTap: () {
        final mood = moodMap[label];
        if (mood == null) return;

        Get.toNamed(
          '/chat',
          arguments: {
            'moodKey': label,
            'openingMessage': mood.openingMessage,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accentColor.withOpacity(0.2),
              accentColor.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: accentColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: accentColor.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatures(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
      children: [
        _feature(
          Icons.auto_awesome_rounded,
          'AI Chat',
          const [Color(0xFF06B6D4), Color(0xFF3B82F6)],
              () => Get.toNamed('/chat'),
        ),
        _feature(
          Icons.trending_up_rounded,
          'Progress',
          const [Color(0xFF8B5CF6), Color(0xFFEC4899)],
              () => Get.toNamed(AppRoute.progress),
        ),
        _feature(
          Icons.groups_rounded,
          'Community',
          const [Color(0xFFEC4899), Color(0xFFF97316)],
              () => Get.toNamed(AppRoute.community_chat),
        ),
        _feature(
          Icons.edit_note_rounded,
          'Journal',
          const [Color(0xFF10B981), Color(0xFF06B6D4)],
              () => Get.toNamed(AppRoute.journal),
        ),
      ],
    );
  }

  Widget _feature(IconData icon, String title, List<Color> gradientColors, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E3F),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) {
          setState(() => _selectedIndex = i);

          if (i == 1) Get.toNamed('/chat');
          if (i == 2) Get.toNamed('/progress');
          if (i == 3) Get.toNamed('/settings');
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF06B6D4),
        unselectedItemColor: Colors.white.withOpacity(0.4),
        selectedFontSize: 12,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: _selectedIndex == 0
                    ? const LinearGradient(
                  colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
                )
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.home_rounded),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: _selectedIndex == 1
                    ? const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                )
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.chat_bubble_rounded),
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: _selectedIndex == 2
                    ? const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFFF97316)],
                )
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.trending_up_rounded),
            ),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: _selectedIndex == 3
                    ? const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
                )
                    : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.settings_rounded),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}