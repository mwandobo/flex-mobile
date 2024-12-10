import 'package:flex_mobile/core/constants/app.dart';
import 'package:flex_mobile/features/resource/resource-details-screen.dart';
import 'package:flex_mobile/features/resource/resource-item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/service/auth_service.dart';

class ResourceList extends StatefulWidget {
  final dynamic from;
  final dynamic fromId;

  const ResourceList({Key? key, required this.from, required this.fromId})
      : super(key: key);

  @override
  _ResourceListState createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceList> {
  List<dynamic> resources = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchResources();
  }

  Future<void> _fetchResources() async {
    final queryParameters = {
      'for': widget.from.toString(), // Use `indicatorId` otherwise
      'for_id': widget.fromId.toString(), // Use `indicatorId` otherwise
    };

    final url = Uri.parse(
        '${AppConstants.baseUrl}resource?${Uri(queryParameters: queryParameters).query}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          resources = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching resources: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Resources",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: resources.length,
                        itemBuilder: (context, index) {
                          final resource = resources[index];
                          return GestureDetector(
                              onTap: () {
                                // Navigate to the detail screen with the selected indicator.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ResourceDetailScreen(
                                        resource: resource),
                                  ),
                                );
                              },
                              child: ResourceListItem(
                                name: resource['resource_name'] ?? 'N/A',
                                quantity: resource['quantity'] ?? 0,
                                amount: resource['amount'] ?? 0,
                                status: resource['status'] ?? 'N/A',
                                index: index + 1,
                              ));
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
