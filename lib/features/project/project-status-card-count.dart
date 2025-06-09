import 'package:flutter/material.dart';

class ProjectStatusCardCount extends StatelessWidget {
  final IconData? icon; // Changed from dynamic to IconData
  final String title;
  final Color borderColor;
  final int count;

  const ProjectStatusCardCount({
    Key? key,
    this.icon, // No longer required
    required this.title,
    required this.borderColor,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
      height: 140,
      child: Card(
        elevation: 4, // Adds a shadow to elevate the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: borderColor,
            width: 1, // Thickness of the border
          ),
        ),
        color: Colors.white, // No background color, pure white
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: borderColor
            // gradient: LinearGradient(
            //   colors: [
            //     borderColor.withOpacity(0.1), // Subtle gradient effect
            //     Colors.white,
            //   ],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            // ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  // Only show if icon exists
                  Icon(
                    icon!,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white, // Title color matches border
                    fontSize: 12, // Reduced size
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white, // Count color matches border
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
