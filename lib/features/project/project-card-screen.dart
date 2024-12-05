import 'package:flex_mobile/features/project/project-card-list-screen.dart';
import 'package:flutter/material.dart';

class ProjectCardScreen extends StatelessWidget {
  final dynamic project;

  const ProjectCardScreen({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final projectId = project['id'];

    return Scaffold(
      appBar: AppBar(title: Text(project['name'] ?? "Project Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Name: ${project['name'] ?? 'N/A'}',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildCard(context,
                      title: 'Goals', color: Colors.blue, projectId: projectId),
                  _buildCard(context,
                      title: 'Outcomes',
                      color: Colors.green,
                      projectId: projectId),
                  _buildCard(context,
                      title: 'Outputs',
                      color: Colors.orange,
                      projectId: projectId),
                  _buildCard(context,
                      title: 'Activities',
                      color: Colors.red,
                      projectId: projectId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required Color color,
    required int projectId,
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
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.list, size: 48, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
