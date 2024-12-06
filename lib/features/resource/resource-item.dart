import 'package:flutter/material.dart';

class ResourceListItem extends StatelessWidget {
  final String name;
  final int quantity;
  final String status;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ResourceListItem({
    Key? key,
    required this.name,
    required this.quantity,
    required this.status,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  Color getStatusColor() {
    switch (status) {
      case "available":
        return Colors.green;
      case "unavailable":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                color: getStatusColor(),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Quantity: $quantity",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              status,
              style: TextStyle(
                fontSize: 14,
                color: getStatusColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              color: Colors.blue,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
