import 'package:flex_mobile/features/collected-data-cost/collected-data-cost-item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/service/auth_service.dart';

class CollectedDataCostList extends StatefulWidget {
  final dynamic indicator;
  final String costType;

  const CollectedDataCostList(
      {Key? key, required this.indicator, required this.costType})
      : super(key: key);

  @override
  _CollectedDataCostListState createState() => _CollectedDataCostListState();
}

class _CollectedDataCostListState extends State<CollectedDataCostList> {
  final TextEditingController _amountController = TextEditingController();

  List<dynamic> collectedDatas = [];
  bool isLoading = true;
  bool isAdding = false;
  bool isEditing = false;
  String? errorMessage;
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchCollectedDatas();
  }

  Future<void> _fetchCollectedDatas() async {
    final costType = widget.costType;
    final indicatorId = widget.indicator['id'];

    final queryParameters = {
      'indicator_id': indicatorId.toString(), // Use `indicatorId` otherwise
      'cost_type': costType, // Add `cost_type` only if provided
    };

    final url =
        Uri.http('10.0.2.2:8000', '/api/collected_data', queryParameters);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          collectedDatas = data['data'];
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
        errorMessage = "Error fetching CollectedDatas: $e";
      });
    }
  }

  Future<void> _addCollectedData() async {
    final activityId =
        widget.indicator['for_id'] ?? widget.indicator['from_id'];
    final indicatorId = widget.indicator['id'];
    final costType = widget.costType;

    final url = Uri.parse('http://10.0.2.2:8000/api/collected_data');
    final body = jsonEncode({
      'amount': _amountController.text,
      'from': costType,
      'from_id': indicatorId,
      'indicator_id': activityId,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          isAdding = false;
          _amountController.clear();
          _fetchCollectedDatas();
        });
      } else {
        setState(() {
          errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error adding CollectedData: $e";
      });
    }
  }

  Future<void> _editCollectedData(int id) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/collected_data/$id');
    final body = jsonEncode({
      'amount': _amountController.text,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}'
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          isEditing = false;
          _amountController.clear();
          editingIndex = null;
          _fetchCollectedDatas();
        });
      } else {
        setState(() {
          errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error editing CollectedData: $e";
      });
    }
  }

  Future<void> _deleteCollectedData(int id) async {
    final url =
        Uri.parse('http://10.0.2.2:8000/api/collected_data/$id?type=occur');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}'
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _fetchCollectedDatas();
        });
      } else {
        setState(() {
          errorMessage =
              "Error deleting Collected Data: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error deleting Collected Data: $e";
      });
    }
  }

  // Confirmation dialog for deleting data
  Future<void> _showDeleteConfirmationDialog(int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Are you sure?"),
          content: const Text(
              "Do you really want to delete this item? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteCollectedData(id); // Proceed with delete
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddForm() {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: isEditing
                ? () {
                    _editCollectedData(collectedDatas[editingIndex!]['id']);
                  }
                : _addCollectedData,
            child:
                Text(isEditing ? 'Edit Collected Data' : 'Add Collected Data'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Collected Data",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            isAdding = !isAdding;
                            isEditing = false; // Reset edit state
                          });
                        },
                      ),
                    ])),
          ),
          if (isAdding) Expanded(child: _buildAddForm()),
          if (isEditing) Expanded(child: _buildAddForm()),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(child: Text(errorMessage!))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: collectedDatas.length,
                        itemBuilder: (context, index) {
                          final collectedData = collectedDatas[index];
                          return CollectedDataCostListItem(
                            index: index + 1,
                            amount: collectedData['amount'],
                            onEdit: () {
                              setState(() {
                                isEditing = true;
                                _amountController.text =
                                    collectedData['amount'];
                                editingIndex = index;
                                isAdding = false;
                              });
                            },
                            onDelete: () {
                              _showDeleteConfirmationDialog(
                                  collectedData['id']);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
