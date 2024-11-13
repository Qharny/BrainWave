import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quizapp/screen/dashboard.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); // Added for registration
  bool _isLogin = true;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final userBox = Hive.box('userBox');
      
      if (_isLogin) {
        // Login logic
        final userData = userBox.get('users_${_emailController.text}');
        if (userData != null && userData['password'] == _passwordController.text) {
          // Set current user data
          userBox.put('currentUser', {
            'email': _emailController.text,
            'name': userData['name'],
            'quizzesTaken': userData['quizzesTaken'] ?? 0,
            'averageScore': userData['averageScore'] ?? 0.0,
          });
          
          userBox.put('isLoggedIn', true);
          
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const QuizDashboard()),
            );
          }
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid credentials')),
          );
        }
      } else {
        // Registration logic
        await userBox.put('users_${_emailController.text}', {
          'password': _passwordController.text,
          'name': _nameController.text,
          'quizzesTaken': 0,
          'averageScore': 0.0,
        });

        // Set current user data
        userBox.put('currentUser', {
          'email': _emailController.text,
          'name': _nameController.text,
          'quizzesTaken': 0,
          'averageScore': 0.0,
        });
        
        userBox.put('isLoggedIn', true);
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const QuizDashboard()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isLogin ? 'Welcome Back!' : 'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 30),
                if (!_isLogin)
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter your name' : null,
                  ).animate().fadeIn().slideX(),
                if (!_isLogin) const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter email' : null,
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter password' : null,
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_isLogin ? 'Login' : 'Register'),
                ).animate().fadeIn().slideX(),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(
                    _isLogin
                        ? 'Need an account? Register'
                        : 'Have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}