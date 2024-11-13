import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quizapp/screen/settings.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box('userBox');
    final user = userBox.get('currentUser', defaultValue: {
      'email': 'guest@example.com',
      'name': 'Guest User',
      'quizzesTaken': 0,
      'averageScore': 0.0,
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                user['name'][0],
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ).animate()
              .scale(duration: const Duration(milliseconds: 300)),
            const SizedBox(height: 20),
            Text(
              user['name'],
              style: Theme.of(context).textTheme.headlineSmall,
            ).animate()
              .fadeIn()
              .slideY(),
            Text(
              user['email'],
              style: Theme.of(context).textTheme.bodyLarge,
            ).animate()
              .fadeIn()
              .slideY(),
            const SizedBox(height: 30),
            const Divider(),
            _buildStatsSection(context, user),
            const Divider(),
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, Map user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Stats',
            style: Theme.of(context).textTheme.titleLarge,
          ).animate()
            .fadeIn()
            .slideX(),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard(
                context,
                'Quizzes Taken',
                '${user['quizzesTaken']}',
                Icons.quiz,
              ),
              _buildStatCard(
                context,
                'Average Score',
                '${user['averageScore']}%',
                Icons.score,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate()
      .scale(duration: const Duration(milliseconds: 300));
  }

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ).animate()
            .fadeIn()
            .slideX(),
          const SizedBox(height: 16),
          _buildActionButton(
            context,
            'Edit Profile',
            Icons.edit,
            () => _showEditProfileDialog(context),
          ),
          _buildActionButton(
            context,
            'View History',
            Icons.history,
            () => _showQuizHistory(context),
          ),
          _buildActionButton(
            context,
            'Reset Progress',
            Icons.restart_alt,
            () => _showResetConfirmation(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    ).animate()
      .fadeIn()
      .slideX();
  }

  void _showEditProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => EditProfileDialog(
      onSave: (newUserData) {
        _updateUserData(newUserData); // Update user data in Hive
      },
    ),
  );
}

  void _showQuizHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QuizHistoryScreen(),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'Are you sure you want to reset all your quiz progress? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Reset progress logic here
              _resetUserProgress(); // Call reset function
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _updateUserData(Map<String, dynamic> newUserData) {
    final userBox = Hive.box('userBox');
    userBox.put('currentUser', newUserData); // Update user data in Hive
  }

  void _resetUserProgress() {
    final userBox = Hive.box('userBox');
    userBox.put('currentUser', { // Reset user data
      'email': 'guest@example.com',
      'name': 'Guest User',
      'quizzesTaken': 0,
      'averageScore': 0.0,
    });
  }
}