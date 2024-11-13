import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quizapp/auth/auth.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/theme/theme_notifier.dart';
import 'package:quizapp/theme/text_size_notifier.dart';
import 'package:quizapp/theme/sound_notifier.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final textSizeNotifier = Provider.of<TextSizeNotifier>(context);
    final soundNotifier = Provider.of<SoundNotifier>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF252525), // Slightly lighter dark
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildSettingsSection(
            context,
            'Appearance',
            [
              _buildSettingsTile(
                context,
                'Dark Mode',
                Icons.dark_mode,
                trailing: Switch.adaptive(
                  value: themeNotifier.isDarkMode,
                  onChanged: (value) => themeNotifier.toggleTheme(),
                  activeColor: Colors.blue[400],
                  activeTrackColor: Colors.blue.withOpacity(0.3),
                ),
                bottomBorder: true,
              ),
              _buildSettingsTile(
                context,
                'Text Size',
                Icons.text_fields,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF303030),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<double>(
                    value: textSizeNotifier.textSize,
                    dropdownColor: const Color(0xFF303030),
                    underline: Container(),
                    style: const TextStyle(color: Colors.white),
                    items: [12.0, 16.0, 20.0, 24.0]
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text('${size.toInt()} pt'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) textSizeNotifier.setTextSize(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          _buildSettingsSection(
            context,
            'Sound Settings',
            [
              _buildSettingsTile(
                context,
                'Sound Effects',
                Icons.volume_up,
                trailing: Switch.adaptive(
                  value: soundNotifier.isSoundEnabled,
                  onChanged: (value) => soundNotifier.toggleSound(),
                  activeColor: Colors.blue[400],
                  activeTrackColor: Colors.blue.withOpacity(0.3),
                ),
              ),
            ],
          ),
          _buildSettingsSection(
            context,
            'Quiz Preferences',
            [
              _buildSettingsTile(
                context,
                'Difficulty',
                Icons.speed,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF303030),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: 'Medium',
                    dropdownColor: const Color(0xFF303030),
                    underline: Container(),
                    style: const TextStyle(color: Colors.white),
                    items: ['Easy', 'Medium', 'Hard']
                        .map((difficulty) => DropdownMenuItem(
                              value: difficulty,
                              child: Text(difficulty),
                            ))
                        .toList(),
                    onChanged: (value) {
                      // Implement difficulty changing
                    },
                  ),
                ),
              ),
            ],
          ),
          _buildSettingsSection(
            context,
            'Account',
            [
              _buildSettingsTile(
                context,
                'Change Password',
                Icons.lock,
                onTap: () {
                  // Implement password change
                },
                bottomBorder: true,
              ),
              _buildSettingsTile(
                context,
                'Privacy Settings',
                Icons.privacy_tip,
                onTap: () {
                  // Implement privacy settings
                },
                bottomBorder: true,
              ),
              _buildSettingsTile(
                context,
                'Logout',
                Icons.logout,
                textColor: Colors.redAccent,
                onTap: () {
                  Hive.box('user').clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AuthScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> tiles,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF252525),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: tiles),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
    bool bottomBorder = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: bottomBorder
            ? const Border(
                bottom: BorderSide(
                  color: Color(0xFF303030),
                  width: 1,
                ),
              )
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(
          icon,
          color: Colors.blue[400],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 16,
          ),
        ),
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: onTap,
      ),
    );
  }
}
