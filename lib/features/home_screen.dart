import 'package:flex_mobile/features/auth/screens/login_screen.dart';
import 'package:flex_mobile/features/auth/screens/profile_screen.dart';
import 'package:flex_mobile/features/auth/service/auth_service.dart';
import 'package:flex_mobile/features/project/project-list.dart';
import 'package:flutter/material.dart';

import '../core/constants/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  Future<void> _logout() async {
    final AuthService authService = AuthService();
    await authService.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Projects',
      'widget': const ProjectList(),
    },
    {
      'title': 'Profile',
      'widget': const ProfileScreen(),
    },
  ];

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        // margin: const EdgeInsets.symmetric(vertical: 6), // Prevent overflow
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.newPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.newPrimaryColor,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {
            // Add your drawer or action here
          },
        ),
        title: Center(
          child: Text(
            _pages[_currentIndex]['title'],
            style: const TextStyle(
                fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout,
              color: Colors.white,
              size: 32),
          ),
        ],
      ),

      body: _pages[_currentIndex]['widget'],
      bottomNavigationBar: BottomAppBar(
        color: AppColors.newPrimaryColor, // Background for the entire bottom bar (optional)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.list,
              label: 'Projects',
              index: 0,
            ),
            _buildNavItem(
              icon: Icons.person,
              label: 'Profile',
              index: 1,
            ),
          ],
        ),
      ),

    );
  }
}



