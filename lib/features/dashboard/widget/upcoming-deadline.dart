import 'package:flutter/material.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class UpcomingDeadlineCard extends StatelessWidget {
  UpcomingDeadlineCard({super.key});

  final List<Map<String, dynamic>> deadlineTasks = [
    {
      'icon': Icons.assignment_turned_in,
      'title': 'Submit Report',
      'dueDate': 'Jun 10',
      'iconColor': Colors.green,
    },
    {
      'icon': Icons.code,
      'title': 'Push Final Code',
      'dueDate': 'Jun 11',
      'iconColor': Colors.deepPurple,
    },
    {
      'icon': Icons.bug_report,
      'title': 'Fix Critical Bug',
      'dueDate': 'Jun 12',
      'iconColor': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8)
          , color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Card title
          const Text(
            "Upcoming Deadlines",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black
            ),
          ),
          const SizedBox(height: 4),

          /// Scrollable task list
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: deadlineTasks.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final task = deadlineTasks[index];
                return _buildTaskItem(task);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget for each task
  Widget _buildTaskItem(Map<String, dynamic> task) {
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(
            Typicons.pin,
            size: 20, // Adjust size as needed
            color: Colors.red,

          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Due: ${task['dueDate']}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,

                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
