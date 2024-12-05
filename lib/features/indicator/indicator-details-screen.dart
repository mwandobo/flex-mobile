import 'package:flutter/material.dart';

class IndicatorDetailScreen extends StatelessWidget {
  final dynamic indicator;

  const IndicatorDetailScreen({Key? key, required this.indicator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(indicator['name'] ?? "Indicator Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${indicator['name'] ?? 'N/A'}',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text('Code: ${indicator['formatted_code'] ?? 'N/A'}'),
            Text('Status: ${indicator['status'] ?? 'N/A'}'),
            const SizedBox(height: 20),
            const Divider(),
            Text(
              'Additional Details:',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 10),
            Text(
                'Description: ${indicator['description'] ?? 'No description'}'),
            Text('Created At: ${indicator['created_at'] ?? 'N/A'}'),
            Text('Updated At: ${indicator['updated_at'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}
