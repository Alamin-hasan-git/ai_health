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
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
                children: [
                  _buildMoodCard(context),
                  const SizedBox(height: 24),
                  _buildFeatures(context),
                  const SizedBox(height: 24),
                  Text('Need a laugh? Check out these memes!', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  MemeListPage()
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Welcome back 👋',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }


  Widget _buildMoodCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.deepPurple.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How are you feeling today?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMoodOption('😢', 'Sad'),
              _buildMoodOption('😰', 'Anxious'),
              _buildMoodOption('😠', 'Angry'),
              _buildMoodOption('🫩', 'Tired'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOption(String emoji, String label) {
    return GestureDetector(
      onTap: () {
        final mood = moodMap[label];
        if (mood == null) return;

        Get.toNamed(
          '/chat',
          arguments: {
            'feelingPrompt': mood.feelingPrompt,
            'openingMessage': mood.openingMessage,
          },
        );
      },
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
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
      children: [
        _feature(Icons.chat, 'AI Chat', () => Get.toNamed('/chat')),
        _feature(Icons.bar_chart, 'Progress', () => Get.toNamed(AppRoute.progress)),
        _feature(Icons.wechat_outlined, 'Community Chat', () => Get.toNamed(AppRoute.community_chat)),
        _feature(Icons.favorite, 'Wellness', () => Get.toNamed('/wellness')),
      ],
    );
  }

  Widget _feature(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.deepPurple.withOpacity(0.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }


  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (i) {
        setState(() => _selectedIndex = i);

        if (i == 1) Get.toNamed('/chat');
        if (i == 2) Get.toNamed('/progress');
        if (i == 3) Get.toNamed('/settings');
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}