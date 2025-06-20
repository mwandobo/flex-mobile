import 'package:flutter/material.dart';

class IndicatorListItem extends StatelessWidget {
  final String name;
  final String formattedCode;
  final String status;

  const IndicatorListItem({
    Key? key,
    required this.name,
    required this.formattedCode,
    required this.status,
  }) : super(key: key);

  // Status color and text based on status
  Color getStatusColor() {
    switch (status) {
      case "pending":
        return Colors.grey;
      case "onprogress":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getStatusText() {
    return status;
  }

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
                    "Code: $formattedCode",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              getStatusText(),
              style: TextStyle(
                fontSize: 14,
                color: getStatusColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
