import 'package:flex_mobile/core/constants/app.dart';
import 'package:flex_mobile/features/collected-data/collected-data-item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/service/auth_service.dart';

class CollectedDataList extends StatefulWidget {
  final dynamic indicator;

  const CollectedDataList({Key? key, required this.indicator})
      : super(key: key);

  @override
  _CollectedDataListState createState() => _CollectedDataListState();
}

class _CollectedDataListState extends State<CollectedDataList> {
  final TextEditingController _quantityController = TextEditingController();

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
    final indicatorId = widget.indicator['id'];

    final queryParameters = {
      'indicator_id': indicatorId.toString(), // Use `indicatorId` otherwise
    };

    // final url =
    // Uri.http('10.0.2.2:8000', '/api/collected_data', queryParameters);

    final url = Uri.parse(
        '${AppConstants.baseUrl}collected_data?${Uri(queryParameters: queryParameters).query}');

    // Uri url = Uri.parse('$baseUrl?${Uri(queryParameters: queryParameters).query}');

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
    final indicatorId = widget.indicator['id'];

    final url = Uri.parse('http://10.0.2.2:8000/api/collected_data');
    final body = jsonEncode({
      'quantity': _quantityController.text,
      'indicator_id': indicatorId,
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
          _quantityController.clear();
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
      'quantity': _quantityController.text,
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
          _quantityController.clear();
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
    final url = Uri.parse('http://10.0.2.2:8000/api/collected_data/$id');

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
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
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
                          return CollectedDataListItem(
                            index: index + 1,
                            quantity: collectedData['quantity'],
                            onEdit: () {
                              setState(() {
                                isEditing = true;
                                _quantityController.text =
                                    collectedData['quantity'].toString();
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
