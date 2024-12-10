import 'dart:convert';
import 'package:flex_mobile/core/constants/app.dart';
import 'package:flex_mobile/features/auth/service/auth_service.dart';
import 'package:flex_mobile/features/project/project-card-screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProjectDetailScreen extends StatefulWidget {
  final int projectId;

  const ProjectDetailScreen({Key? key, required this.projectId})
      : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  Map<String, dynamic>? data;
  Map<String, dynamic>? project;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProjectDetails();
  }

  Future<void> _fetchProjectDetails() async {
    final url = Uri.parse(
        '${AppConstants.baseUrl}project_planning/show/${widget.projectId}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}'
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          final result = json.decode(response.body);
          data = result['data'];
          project = data?['project'];

          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load project details.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(project?['name'] ?? 'Project Details')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : project != null
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${project!['name'] ?? "N/A"}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(height: 8),
                          Text('Code: ${project!['code'] ?? "N/A"}'),
                          const SizedBox(height: 8),
                          Text('Status: ${project!['status'] ?? "N/A"}'),
                          const SizedBox(height: 8),
                          Text(
                              'Start Date: ${project!['formatted_start_date'] ?? "Not Available"}'),
                          const SizedBox(height: 8),
                          Text(
                              'End Date: ${project!['formatted_end_date'] ?? "Not Available"}'),
                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ProjectCardScreen(data: data!),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text('No project data available.')),
    );
  }
}
