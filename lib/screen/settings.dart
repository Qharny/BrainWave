import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quizapp/auth/auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSettingsSection(
            context,
            'Appearance',
            [
              _buildSettingsTile(
                context,
                'Dark Mode',
                Icons.dark_mode,
                trailing: Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    // Implement theme switching
                  },
                ),
              ),
              _buildSettingsTile(
                context,
                'Text Size',
                Icons.text_fields,
                trailing: DropdownButton<String>(
                  value: 'Normal',
                  items: ['Small', 'Normal', 'Large']
                      .map((size) => DropdownMenuItem(
                            value: size,
                            child: Text(size),
                          ))
                      .toList(),
                  onChanged: (value) {
                    // Implement text size changing
                  },
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
                'Sound Effects',
                Icons.volume_up,
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // Implement sound toggle
                  },
                ),
              ),
              _buildSettingsTile(
                context,
                'Difficulty',
                Icons.speed,
                trailing: DropdownButton<String>(
                  value: 'Medium',
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
              ),
              _buildSettingsTile(
                context,
                'Privacy Settings',
                Icons.privacy_tip,
                onTap: () {
                  // Implement privacy settings
                },
              ),
              _buildSettingsTile(
                context,
                'Logout',
                Icons.logout,
                textColor: Colors.red,
                onTap: () {
                  // Implement logout
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
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...tiles,
        const Divider(),
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
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// Additional screens (add these to separate files):

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog(
      {super.key, required Null Function(dynamic newUserData) onSave});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userBox = Hive.box('userBox');
    final user = userBox.get('currentUser', defaultValue: {'name': ''});
    _nameController.text = user['name'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Save profile changes
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class QuizHistoryScreen extends StatelessWidget {
  const QuizHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with actual history count
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${90 - index}%'),
              ),
              title: Text('Science Quiz ${index + 1}'),
              subtitle: Text(
                  'Completed on ${DateTime.now().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Show detailed quiz results
              },
            ),
          );
        },
      ),
    );
  }
}
