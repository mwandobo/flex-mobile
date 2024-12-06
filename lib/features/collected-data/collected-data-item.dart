import 'package:flutter/material.dart';

class CollectedDataListItem extends StatelessWidget {
  final String quantity;
  final String description;
  final int index; // New property to hold the index (numbering)

  const CollectedDataListItem({
    Key? key,
    required this.quantity,
    required this.description,
    required this.index, // Add index parameter to show numbering
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$index.', // Display the index (numbering) at the start
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8), // Spacing between number and content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Quantity: ', // Label for quantity
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        quantity,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text(
                        'Description: ', // Label for quantity
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
