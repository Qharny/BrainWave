import 'package:flutter/material.dart';

class SoundNotifier extends ChangeNotifier {
  bool _isSoundEnabled = true; // Default sound state

  bool get isSoundEnabled => _isSoundEnabled;

  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    notifyListeners();
  }
} 