import 'package:flutter/material.dart';

class NavigationService {
  static final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(), // Dashboard
    GlobalKey<NavigatorState>(), // Profile
    GlobalKey<NavigatorState>(), // Help
  ];

  static Future<dynamic>? navigateTo(int tabIndex, String routeName) {
    return navigatorKeys[tabIndex].currentState?.pushNamed(routeName);
  }

  static void pop(int tabIndex) {
    navigatorKeys[tabIndex].currentState?.pop();
  }

  static void popUntilFirst(int tabIndex) {
    navigatorKeys[tabIndex].currentState?.popUntil((route) => route.isFirst);
  }
}
