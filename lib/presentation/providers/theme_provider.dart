import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  
  // --- Theme Logic ---
  static const String _themeKey = 'isDarkMode';
  ThemeMode _themeMode = ThemeMode.light; 
  ThemeMode get themeMode => _themeMode;

  // --- Locale Logic (New) ---
  static const String _languageKey = 'languageCode';
  Locale? _appLocale; // Null means follow system default (System language)
  
  // Supported locales: English (en), Hindi (hi), Malayalam (ml), and Tamil (ta)
  static final allLocales = [
    const Locale('en'),
    const Locale('hi'), 
    const Locale('ml'), 
    const Locale('ta'),
    const Locale('te'),
  ];

  Locale? get appLocale => _appLocale; // Getter for the current selected locale

  ThemeProvider() {
    // Load both theme and language settings when the provider is initialized
    _loadSettings();
  }

  // --- Core Loading Function (Updated to load both settings) ---
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Load Theme Preference
    final isDark = prefs.getBool(_themeKey) ?? false; // Default to light (false)
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    // 2. Load Language Preference
    final langCode = prefs.getString(_languageKey);
    if (langCode != null) {
      _appLocale = Locale(langCode);
    }
    
    notifyListeners();
  }

  // --- Theme Control ---
  // Toggle between light and dark mode
  void toggleTheme(bool isDarkMode) async {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    
    // Save the preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);

    notifyListeners();
  }

  // Helper to check the current dark state for the Switch widget
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  // --- Language Control (New) ---
  void setLocale(Locale newLocale) async {
    _appLocale = newLocale;
    
    // Save the language preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, newLocale.languageCode);
    
    notifyListeners();
  }
}