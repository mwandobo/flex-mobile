import 'package:flex_mobile/features/cost/cost-details-screen.dart';
import 'package:flex_mobile/features/cost/cost-item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/service/auth_service.dart';

class CostList extends StatefulWidget {
  final int projectId;
  const CostList({super.key, required this.projectId});

  @override
  _CostListState createState() => _CostListState();
}

class _CostListState extends State<CostList> {
  List<dynamic> costs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCosts();
  }

  Future<void> _fetchCosts() async {
    var projectId = widget.projectId;
    final url =
        Uri.parse('http://10.0.2.2:8000/api/cost?project_id=$projectId');
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
          costs = data['data'];
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
        errorMessage = "Error fetching costs: $e";
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
                        "Costs",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ])),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: costs.length,
                        itemBuilder: (context, index) {
                          final cost = costs[index];
                          return GestureDetector(
                              onTap: () {
                                // Navigate to the detail screen with the selected indicator.
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CostDetailScreen(cost: cost),
                                  ),
                                );
                              },
                              child: CostListItem(
                                description: cost['description'] ?? 'N/A',
                                amount: cost['amount'] ?? '0.0',
                                category: cost['category'] ?? 'N/A',
                              ));
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
