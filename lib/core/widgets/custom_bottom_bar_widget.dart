import 'package:flex_mobile/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.newPrimaryColor, // transparent background
        // color: Colors.black, // transparent background

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBarItem(icon: FontAwesomeIcons.house, label: 'home', index: 0),
          _buildBarItem(icon: FontAwesomeIcons.user, label: 'profile', index: 1),
          _buildBarItem(icon: Icons.help, label: 'help', index: 2),
        ],
      ),
    );
  }

  Widget _buildBarItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white, // Always white
            size: isSelected ? 26 : 22, // Slightly bigger when selected
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white, // Always white
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: isSelected ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }}
