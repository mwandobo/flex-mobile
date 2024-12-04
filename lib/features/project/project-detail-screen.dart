import 'package:flex_mobile/features/indicator/indicator-list.dart';
import 'package:flutter/material.dart';

class ProjectDetailScreen extends StatelessWidget {
  final dynamic project;

  const ProjectDetailScreen({Key? key, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedStartDate =
        project['formatted_start_date'] ?? 'Not Available';
    final formattedEndDate = project['formatted_end_date'] ?? 'Not Available';
    []; // Assuming indicators are part of project data.

    return Scaffold(
      appBar: AppBar(title: Text(project['name'] ?? "Project Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${project['name'] ?? "N/A"}',
                style: Theme.of(context).textTheme.headline6),
            Text('Code: ${project['code'] ?? "N/A"}'),
            Text('Status: ${project['status'] ?? "N/A"}'),
            Text('Start Date: $formattedStartDate'),
            Text('End Date: $formattedEndDate'),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            Text('Indicators:', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 10),
            const Expanded(child: IndicatorList()),
          ],
        ),
      ),
    );
  }
}
