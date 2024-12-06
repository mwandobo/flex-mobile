import 'package:flutter/material.dart';

class CollectedDataListItem extends StatelessWidget {
  final String quantity;
  final String description;
  final int index;
  final Function onEdit;
  final Function onDelete;

  const CollectedDataListItem({
    Key? key,
    required this.quantity,
    required this.description,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$index.',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Quantity: ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            quantity,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text(
                            'Description: ',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            description,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => onEdit(), // Trigger onEdit callback
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  label:
                      const Text('Edit', style: TextStyle(color: Colors.blue)),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => onDelete(),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
