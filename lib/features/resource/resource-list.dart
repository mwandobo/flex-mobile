import 'package:flex_mobile/features/resource/resource-item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/service/auth_service.dart';

class ResourceList extends StatefulWidget {
  const ResourceList({Key? key}) : super(key: key);

  @override
  _ResourceListState createState() => _ResourceListState();
}

class _ResourceListState extends State<ResourceList> {
  List<dynamic> resources = [];
  bool isLoading = true;
  bool isAdding = false;
  bool isEditing = false;
  String? errorMessage;
  int? editingIndex; // To track the index of the item being edited
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchResources();
  }

  Future<void> _fetchResources() async {
    final url =
        Uri.parse('http://10.0.2.2:8000/api/resource'); // Adjust the URL
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

  Future<void> _addResource() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/resource');
    final body = jsonEncode({
      'name': _nameController.text,
      'quantity': _quantityController.text,
      'status': _statusController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          isAdding = false;
          _nameController.clear();
          _quantityController.clear();
          _statusController.clear();
          _fetchResources();
        });
      } else {
        setState(() {
          errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error adding resource: $e";
      });
    }
  }

  Future<void> _editResource(int id) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/resource/$id');
    final body = jsonEncode({
      'name': _nameController.text,
      'quantity': _quantityController.text,
      'status': _statusController.text,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          isEditing = false;
          _nameController.clear();
          _quantityController.clear();
          _statusController.clear();
          editingIndex = null;
          _fetchResources();
        });
      } else {
        setState(() {
          errorMessage = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error editing resource: $e";
      });
    }
  }

  Future<void> _deleteResource(int id) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/resource/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _fetchResources();
        });
      } else {
        setState(() {
          errorMessage = "Error deleting resource: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error deleting resource: $e";
      });
    }
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to delete this resource?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteResource(id);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
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
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Resource Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8.0),
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
                    _editResource(resources[editingIndex!]['id']);
                  }
                : _addResource,
            child: Text(isEditing ? 'Edit Resource' : 'Add Resource'),
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
                    "Resources",
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
                ],
              ),
            ),
          ),
          if (isAdding || isEditing) Expanded(child: _buildAddForm()),
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
                          return ResourceListItem(
                            name: resource['name'] ?? 'N/A',
                            quantity: resource['quantity'] ?? 0,
                            status: resource['status'] ?? 'N/A',
                            onEdit: () {
                              setState(() {
                                isEditing = true;
                                _nameController.text = resource['name'];
                                _quantityController.text =
                                    resource['quantity'].toString();
                                _statusController.text = resource['status'];
                                editingIndex = index;
                                isAdding = false;
                              });
                            },
                            onDelete: () {
                              _showDeleteConfirmationDialog(resource['id']);
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
