import 'package:flutter/material.dart';

class ActionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final containerHeight = screenHeight * 0.1; // 15% of screen height

    return

      // Padding(
      // // padding: const EdgeInsets.all(16), // Outer padding for the row
      // child:
      //
      Row(
        children: [
          _buildActionItem(
            context: context,
            icon: Icons.add_box, // Rectangular add icon
            text: 'Add Project',
            height: containerHeight,
          ),
          const SizedBox(width: 12), // Space between items
          _buildActionItem(
            context: context,
            icon: Icons.note, // Notepad icon
            text: 'Create Task',
            height: containerHeight,
          ),
          const SizedBox(width: 12), // Space between items
          _buildActionItem(
            context: context,
            icon: Icons.access_time, // Time/Clock icon
            text: 'Track Time',
            height: containerHeight,
          ),
        ],
      // ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    required double height,
  }) {
    return Expanded(
      child: Container(
        height: height, // Responsive height
        // padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center icon and text
          children: [
            Icon(
              icon,
              size: 30,
              color: Colors.blue,
            ),
            // const SizedBox(height: 4),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
