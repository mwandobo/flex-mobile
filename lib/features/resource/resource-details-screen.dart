import 'package:flex_mobile/features/collected-data-cost/collected-data-cost-list.dart';
import 'package:flutter/material.dart';

class ResourceDetailScreen extends StatelessWidget {
  final dynamic resource;

  const ResourceDetailScreen({Key? key, required this.resource})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resource['name'] ?? "resource Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Allow column to adjust height
            children: [
              Text(
                'Name: ${resource['resource_name'] ?? 'N/A'}',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text('Resource Type: ${resource['resource_type_name'] ?? 'N/A'}'),
              Text(
                'Amount: ${resource['amount'] ?? 'No description'}',
              ),
              Text(
                'Quantity: ${resource['quantity'] ?? 'No description'}',
              ),
              Text('Status: ${resource['status'] ?? 'N/A'}'),
              Text('Created At: ${resource['formatted_created_at'] ?? 'N/A'}'),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.of(context).size.height * 0.6, // Limit height
                ),
                child: CollectedDataCostList(
                  indicator: resource,
                  costType: 'resource_cost',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
