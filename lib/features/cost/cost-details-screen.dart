import 'package:flex_mobile/features/collected-data/collected-data-list.dart';
import 'package:flutter/material.dart';

class CostDetailScreen extends StatelessWidget {
  final dynamic cost;

  const CostDetailScreen({Key? key, required this.cost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cost['name'] ?? "cost Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Allow column to adjust height
            children: [
              Text(
                'Name: ${cost['name'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text('Code: ${cost['formatted_code'] ?? 'N/A'}'),
              Text(
                'Description: ${cost['description'] ?? 'No description'}',
              ),
              Text('Status: ${cost['status'] ?? 'N/A'}'),
              Text('Created At: ${cost['formatted_created_at'] ?? 'N/A'}'),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.6, // Limit height
                ),
                child: CollectedDataList(indicator: cost),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
