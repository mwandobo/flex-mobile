import 'package:flutter/material.dart';
import 'package:flex_mobile/features/project/project-card-list-screen.dart';

class ProjectCardScreen extends StatelessWidget {
  final dynamic data;

  const ProjectCardScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final project = data['project'];
    final projectId = project['id'];

    print('dataaa $data');
    print('goals ${data['goals']}');
    print('outcomes.............. ${data['outcomes']}');

    // Extract totals for each category from project data
    final totalGoals = (data['goals'] as List?)?.length ?? 0;
    final totalOutcomes = (data['outcomes'] as List?)?.length ?? 0;
    final totalOutputs = (data['outputs'] as List?)?.length ?? 0;
    final totalActivities = (data['activities'] as List?)?.length ?? 0;

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
                  totalItems: totalGoals,
                ),
                _buildCard(
                  context,
                  title: 'Outcomes',
                  icon: Icons.trending_up_outlined,
                  color: Colors.green,
                  projectId: projectId,
                  totalItems: totalOutcomes,
                ),
                _buildCard(
                  context,
                  title: 'Outputs',
                  icon: Icons.pie_chart_outline,
                  color: Colors.orange,
                  projectId: projectId,
                  totalItems: totalOutputs,
                ),
                _buildCard(
                  context,
                  title: 'Activities',
                  icon: Icons.task_alt_outlined,
                  color: Colors.red,
                  projectId: projectId,
                  totalItems: totalActivities,
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
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
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
