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
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> collectedDatas = [];
  bool isLoading = true;
  bool isAdding = false; // State for showing the form
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCollectedDatas();
  }

  Future<void> _fetchCollectedDatas() async {
    final url =
        Uri.parse('http://10.0.2.2:8000/api/collected_data'); // Adjust the URL
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
    final indicatorId = widget.indicator['id']; // Access the indicator ID

    final url =
        Uri.parse('http://10.0.2.2:8000/api/collected_data'); // Adjust the URL
    final body = jsonEncode({
      'quantity': _quantityController.text,
      'description': _descriptionController.text,
      'indicator_id': indicatorId
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
          _descriptionController.clear();
          _fetchCollectedDatas(); // Refresh the list after adding
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

  Widget _buildAddForm() {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: MediaQuery.of(context)
            .viewInsets
            .bottom, // Adjust based on keyboard
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Allow column to shrink
        children: [
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: _addCollectedData,
            child: const Text('Add Collected Data'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Collected Data List'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  isAdding = !isAdding;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            if (isAdding)
              Expanded(
                child: SingleChildScrollView(
                  child: _buildAddForm(),
                ),
              ),
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
                            return GestureDetector(
                              child: CollectedDataListItem(
                                quantity: collectedData['quantity'] ?? 'N/A',
                                description:
                                    collectedData['description'] ?? 'N/A',
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
