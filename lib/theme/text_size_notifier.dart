import 'package:flutter/material.dart';

class TextSizeNotifier extends ChangeNotifier {
  double _textSize = 16.0; 
  

  double get textSize => _textSize;

  void setTextSize(double newSize) {
    _textSize = newSize;
    notifyListeners();
  }
} 