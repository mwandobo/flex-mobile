import 'package:flutter/material.dart';

class ResourceListItem extends StatelessWidget {
  final String name;
  final dynamic amount;
  final dynamic quantity;
  final String status;
  final int index;

  const ResourceListItem({
    Key? key,
    required this.name,
    required this.amount,
    required this.status,
    required this.quantity,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      elevation: 2.0, // Slight shadow for better emphasis
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0), // Reduced border radius
        side: BorderSide(
          color: Colors.grey.shade300, // Subtle border color
          width: 1.0, // Reduced border size
        ),
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow:
                        TextOverflow.ellipsis, // Truncate text if it overflows
                    maxLines: 1, // Ensure the name fits in one line
                  ),
                ),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    // color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4.0), // Space between name and other details

            // Wrap the details row to allow them to wrap to a new line
            Align(
              alignment:
                  Alignment.centerRight, // Align all children to the right
              child: Wrap(
                spacing: 8.0, // Space between details
                children: [
                  _buildDetailText('Amount: $amount'),
                  _buildDetailText('quantity: $quantity'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to avoid code repetition for styling text
  Widget _buildDetailText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12, // Smaller font size for project details
        color: Colors.grey[600],
      ),
      overflow: TextOverflow.ellipsis, // Ensures no overflow
    );
  }
}
