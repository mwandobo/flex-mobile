import 'package:flex_mobile/features/project/project-card-screen.dart';
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

  Future<void> _fetchProjects() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/project'); // Adjust the URL
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await AuthService().getToken()}'
        },
      );

      print("response , $response");

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the project detail screen when the item is tapped.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectCardScreen(project: project),
              ),
            );
          },
          child: ProjectListItem(
            name: project['name'] ?? "def name",
            formattedCode: project['code'] ?? "def code",
            status: project['status'] ?? "def project",
          ),
        );
      },
    );
  }
}
