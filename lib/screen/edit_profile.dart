import 'package:flutter/material.dart';

class EditProfileDialog extends StatelessWidget {
  final Function(Map<String, dynamic>) onSaved;

  const EditProfileDialog({super.key, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    // Your dialog UI here
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Add your input fields here
          TextField(
            decoration: InputDecoration(labelText: 'Name'),
            // Capture the input and call onSaved when done
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Email'),
            // Capture the input and call onSaved when done
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Collect the new user data
            Map<String, dynamic> newUserData = {
              'name': 'New Name', // Replace with actual input
              'email': 'newemail@example.com', // Replace with actual input
              // Add other fields as necessary
            };
            onSaved(newUserData); // Call the onSaved function
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
