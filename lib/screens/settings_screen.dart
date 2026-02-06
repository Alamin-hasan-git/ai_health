import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667EEA),
                Color(0xFF764BA2),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Account Section
            _buildSection(
              'Account',
              [
                _buildSettingItem(
                  icon: Icons.person,
                  title: 'Profile',
                  subtitle: 'Edit your profile',
                  onTap: () => Get.snackbar('Profile', 'Profile settings coming soon'),
                ),
                _buildSettingItem(
                  icon: Icons.security,
                  title: 'Security',
                  subtitle: 'Change password',
                  onTap: () => Get.snackbar('Security', 'Security settings coming soon'),
                ),
                _buildSettingItem(
                  icon: Icons.privacy_tip,
                  title: 'Privacy',
                  subtitle: 'Manage privacy settings',
                  onTap: () => Get.snackbar('Privacy', 'Privacy settings coming soon'),
                ),
              ],
            ),

            // Notifications Section
            _buildSection(
              'Notifications',
              [
                _buildToggleItem(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  subtitle: 'Enable push notifications',
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
                _buildSettingItem(
                  icon: Icons.alarm,
                  title: 'Reminders',
                  subtitle: 'Set daily reminders',
                  onTap: () => Get.snackbar('Reminders', 'Reminder settings coming soon'),
                ),
              ],
            ),

            // Preferences Section
            _buildSection(
              'Preferences',
              [
                _buildToggleItem(
                  icon: Icons.dark_mode,
                  title: 'Dark Mode',
                  subtitle: 'Enable dark theme',
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() => _darkModeEnabled = value);
                  },
                ),
                _buildSettingItem(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English',
                  onTap: () => Get.snackbar('Language', 'Language settings coming soon'),
                ),
              ],
            ),

            // About Section
            _buildSection(
              'About',
              [
                _buildSettingItem(
                  icon: Icons.info,
                  title: 'About AI Health',
                  subtitle: 'Version 1.0.0',
                  onTap: () => Get.snackbar('About', 'AI Health - Your mental health companion'),
                ),
                _buildSettingItem(
                  icon: Icons.description,
                  title: 'Terms & Conditions',
                  subtitle: 'Read our terms',
                  onTap: () => Get.snackbar('Terms', 'Opening terms and conditions'),
                ),
                _buildSettingItem(
                  icon: Icons.security,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () => Get.snackbar('Privacy', 'Opening privacy policy'),
                ),
              ],
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GestureDetector(
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back(); // Close dialog
                            Get.offNamed('/login');
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF667EEA),
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF667EEA).withValues(alpha: 0.1),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF667EEA),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF667EEA).withValues(alpha: 0.1),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF667EEA),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF667EEA),
          ),
        ],
      ),
    );
  }
}

