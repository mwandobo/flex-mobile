import 'package:flex_mobile/core/constants/app.dart';
import 'package:flex_mobile/features/project/project-detail-screen.dart';
import 'package:flex_mobile/features/project/project-item.dart';
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
      case 'on_rogress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'closed':
        return Colors.green;
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
            // Align the "Projects" title to the left
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
            const SizedBox(height: 8), // Space between Row and ListView

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusCard('Pending', Colors.grey,
                      _countProjectsByStatus('Pending')),
                  _buildStatusCard('On Progress', Colors.orange,
                      _countProjectsByStatus('On Progress')),
                  _buildStatusCard('Completed', Colors.green,
                      _countProjectsByStatus('Completed')),
                  _buildStatusCard(
                      'Closed', Colors.blue, _countProjectsByStatus('Closed')),
                ],
              ),
            ),
            const SizedBox(height: 8), // Space between Row and ListView
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, // Horizontal padding for the list
                    vertical: 8.0), // Vertical padding for the list
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

  Widget _buildStatusCard(String title, Color borderColor, int count) {
    return Expanded(
      child: Card(
        elevation: 4, // Adds a shadow to elevate the card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: borderColor,
            width: 1, // Thickness of the border
          ),
        ),
        color: Colors.white, // No background color, pure white
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                borderColor.withOpacity(0.1), // Subtle gradient effect
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: borderColor, // Title color matches border
                    fontSize: 12, // Reduced size
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: TextStyle(
                    color: borderColor, // Count color matches border
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
