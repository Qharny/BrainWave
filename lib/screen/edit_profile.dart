import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EditProfileDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const EditProfileDialog({super.key, required this.onSave});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userBox = Hive.box('userBox');
    final currentUser = userBox.get('currentUser');
    _nameController.text = currentUser['name'];
    _emailController.text = currentUser['email'];
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
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            enabled: false, // Email cannot be changed
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
            final userBox = Hive.box('userBox');
            final currentUser = userBox.get('currentUser');
            final updatedUser = {
              ...currentUser,
              'name': _nameController.text,
            };
            // Update both currentUser and the user data in users_email
            widget.onSave(updatedUser as Map<String, dynamic>);
            userBox.put('users_${currentUser['email']}', {
              ...userBox.get('users_${currentUser['email']}') as Map<String, dynamic>,
              'name': _nameController.text,
            });
            
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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
      body: const Center(
        child: Text('Quiz History - To be implemented'),
      ),
    );
  }
}