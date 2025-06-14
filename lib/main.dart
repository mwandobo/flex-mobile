import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/service/auth_wrapper_widget.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/home._screen.dart';
import 'features/projects/project_list/screens/project_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flex Projects',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthWrapper(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/projects': (context) => const ProjectListScreen(),
        '/login': (context) => const LoginScreen(),
      },

    );
  }
}
