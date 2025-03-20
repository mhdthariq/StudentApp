import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  Color _primaryColor = Colors.blue;

  ThemeData get themeData => _themeData;
  Color get primaryColor => _primaryColor;

  ThemeProvider() {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedColor = prefs.getInt('themeColor') ?? Colors.blue.value;
    _primaryColor = Color(savedColor);
    _themeData = _createTheme(_primaryColor);
    notifyListeners();
  }

  void updateTheme(Color newColor) async {
    _primaryColor = newColor;
    _themeData = _createTheme(newColor);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeColor', newColor.value);
  }

  ThemeData _createTheme(Color primaryColor) {
    return ThemeData(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      textTheme: GoogleFonts.poppinsTextTheme(),
      useMaterial3: true,
    );
  }
}