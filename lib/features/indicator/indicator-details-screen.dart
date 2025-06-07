import 'package:flex_mobile/features/collected-data/collected-data-list.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Allow column to adjust height
            children: [
              Text(
                'Name: ${indicator['name'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text('Code: ${indicator['formatted_code'] ?? 'N/A'}'),
              Text(
                'Description: ${indicator['description'] ?? 'No description'}',
              ),
              Text('Status: ${indicator['status'] ?? 'N/A'}'),
              Text('Created At: ${indicator['formatted_created_at'] ?? 'N/A'}'),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.6, // Limit height
                ),
                child: CollectedDataList(indicator: indicator),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
