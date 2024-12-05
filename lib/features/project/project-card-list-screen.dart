import 'package:flex_mobile/core/constants/app.dart';
import 'package:flex_mobile/features/auth/service/auth_service.dart';
import 'package:flex_mobile/features/project/project-card-detail-screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListScreen extends StatefulWidget {
  final String title;
  final int projectId;

  const ListScreen({Key? key, required this.title, required this.projectId})
      : super(key: key);

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<dynamic> _items = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Map to associate titles with their corresponding endpoints
  final Map<String, String> _endpointMap = {
    'goals': 'project_goal',
    'outcomes': 'project_outcome',
    'outputs': 'project_output',
    'activities': 'activity',
  };

  final Map<String, String> _detailTittleMap = {
    'goals': 'Goal',
    'outcomes': 'Outcome',
    'outputs': 'Output',
    'activities': 'Activity',
  };

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final String? endpoint = _endpointMap[widget.title.toLowerCase()];

    if (endpoint == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid endpoint for title: ${widget.title}';
      });
      return;
    }

    final String url =
        '${AppConstants.baseUrl}$endpoint?project_id=${widget.projectId}';

    print('Fetching data from: $url'); // Log the URL being called

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}'
        },
      );

      print('Response status: ${response.statusCode}'); // Log the status code
      print('Response body: ${response.body}'); // Log the response body

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('data')) {
          setState(() {
            _items = jsonResponse['data'];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Data not found in response';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to load data. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error occurred: $e';
      });
      print('Error: $e'); // Log the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage)) // Show error message
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectCardDetailScreen(
                                  project: item,
                                  title: _detailTittleMap[
                                          widget.title.toLowerCase()] ??
                                      "Name"),
                            ),
                          );
                        },
                        child: Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10.0,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title
                                  Text(
                                    item['name'] ?? 'N/A',
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),

                                  // Code
                                  Row(
                                    children: [
                                      const Icon(Icons.code,
                                          size: 18.0, color: Colors.blueGrey),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Code: ${item['formatted_code'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),

                                  // Start Date
                                  Row(
                                    children: [
                                      const Icon(Icons.date_range,
                                          size: 18.0, color: Colors.green),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Start Date: ${item['formatted_start_date'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),

                                  // End Date
                                  Row(
                                    children: [
                                      const Icon(Icons.event,
                                          size: 18.0, color: Colors.red),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'End Date: ${item['formatted_end_date'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontSize: 16.0, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),

                                  // Status
                                  Row(
                                    children: [
                                      const Icon(Icons.info_outline,
                                          size: 18.0, color: Colors.orange),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        'Status: ${item['status'] ?? 'N/A'}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )));
                  },
                ),
    );
  }
}
