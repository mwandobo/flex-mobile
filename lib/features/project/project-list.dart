import 'package:flex_mobile/core/constants/app.dart';
import 'package:flex_mobile/features/project/project-detail-screen.dart';
import 'package:flex_mobile/features/project/project-item.dart';
import 'package:flex_mobile/features/project/project-status-card-count.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../auth/service/auth_service.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  List<dynamic> projects = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.grey;
      case 'on_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'closed':
        return Colors.blue;
      default:
        return Colors.grey; // Default color in case of an unknown status
    }
  }

  Future<void> _fetchProjects() async {
    final url = Uri.parse('${AppConstants.baseUrl}project');
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
          projects = data['data'];
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
        errorMessage = "Error fetching Projects: $e";
      });
    }
  }

  int _countProjectsByStatus(String status) {
    return projects.where((project) => project['status'] == status).length;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Projects",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProjectStatusCardCount(
                    title: 'Pending',
                    borderColor: Colors.grey,
                    count: _countProjectsByStatus('pending'),
                  ),
                  ProjectStatusCardCount(
                    title: 'On Progress',
                    borderColor: Colors.orange,
                    count: _countProjectsByStatus('on_progress'),
                  ),
                  ProjectStatusCardCount(
                    title: 'Completed',
                    borderColor: Colors.green,
                    count: _countProjectsByStatus('completed'),
                  ),
                  ProjectStatusCardCount(
                    title: 'Closed',
                    borderColor: Colors.blue,
                    count: _countProjectsByStatus('closed'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProjectDetailScreen(projectId: project['id']),
                        ),
                      );
                    },
                    child: ProjectListItem(
                      name: project['name'] ?? "Default Name",
                      formattedCode: project['code'] ?? "Default Code",
                      status: project['status'] ?? "Default Status",
                      index: index + 1,
                      startDate: project['formatted_start_date'] ?? "N/A",
                      endDate: project['formatted_end_date'] ?? "N/A",
                      statusColor: _getStatusColor(
                          project['status'] ?? "Default Status"),
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
