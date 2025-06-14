import 'package:flutter/material.dart';

class LanguageService extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
  }

  static final supportedLocales = [
    const Locale('en', 'US'), // English
    const Locale('sw', 'TZ'), // Swahili
  ];
}