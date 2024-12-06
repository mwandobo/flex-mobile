import 'package:flex_mobile/features/project/project-card-list-screen.dart';
import 'package:flutter/material.dart';

class ProjectCardScreen extends StatelessWidget {
  final dynamic project;

  const ProjectCardScreen({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectId = project['id'];
    final totalItems = project['total_items'] ??
        0; // Assuming `total_items` is part of the project data

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildCard(
                  context,
                  title: 'Goals',
                  icon: Icons.flag_outlined,
                  color: Colors.blue,
                  projectId: projectId,
                  totalItems: totalItems,
                ),
                _buildCard(
                  context,
                  title: 'Outcomes',
                  icon: Icons.trending_up_outlined,
                  color: Colors.green,
                  projectId: projectId,
                  totalItems: totalItems,
                ),
                _buildCard(
                  context,
                  title: 'Outputs',
                  icon: Icons.pie_chart_outline,
                  color: Colors.orange,
                  projectId: projectId,
                  totalItems: totalItems,
                ),
                _buildCard(
                  context,
                  title: 'Activities',
                  icon: Icons.task_alt_outlined,
                  color: Colors.red,
                  projectId: projectId,
                  totalItems: totalItems,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required int projectId,
    required int totalItems,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListScreen(
              title: title,
              projectId: projectId,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding:
              const EdgeInsets.all(12.0), // Reduced padding for smaller cards
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color), // Reduced icon size
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16, // Reduced font size
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Items: $totalItems',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
