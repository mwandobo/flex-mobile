import 'package:flex_mobile/core/constants/colors.dart';
import 'package:flex_mobile/features/project/model/project-model.dart';
import 'package:flex_mobile/features/project/project-detail-screen.dart';
import 'package:flex_mobile/features/project/project-item.dart';
import 'package:flex_mobile/features/project/project-status-card-count.dart';
import 'package:flex_mobile/features/project/services/project-service.dart';
import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import '../../core/widgets/dialog/custom-error-dialog.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  final ProjectService _projectService = ProjectService();

  List<ProjectModel> projects = [];
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

  final List<Map<String, dynamic>> projectStatuses = [
    {
      'icon': Icons.folder,
      'title': 'Total Projects',
      'borderColor': AppColors.lightBlue,
      'status': 'all',
    },
    {
      'icon': Icons.check_circle,
      'title': 'Completed',
      'borderColor': AppColors.green,
      'status': 'completed',
    },
    {
      'icon': Icons.access_alarm,
      'title': 'In Progress',
      'borderColor': AppColors.amber,
      'status': 'on_progress',
    },
    {
      'icon': Icons.cancel,
      'title': 'Overdue',
      'borderColor': AppColors.red,
      'status': 'overdue',
    },
  ];


  Future<void> _fetchProjects() async {
    try {
      final (success, List<ProjectModel> _projects) = await _projectService.fetchProjects();


      if (success) {
        setState(() {
          projects = _projects;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Error: Something went wrong}";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching Projects: ${ErrorHandler.handle(e)}";
      });
      CustomErrorDialog.showToast("Failed" ,  ErrorHandler.handle(e), context);

    }
  }

  int _countProjectsByStatus(String status) {
    return projects.where((project) => project.status == status).length;
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: projectStatuses.map((status) {
                    return ProjectStatusCardCount(
                      icon: status['icon'] is IconData ? status['icon'] as IconData : Icons.help_outline,
                      title: status['title'],
                      borderColor: status['borderColor'],
                      count: _countProjectsByStatus(status['status']),
                    );
                  }).toList()              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
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
                              ProjectDetailScreen(projectId: project.id),
                        ),
                      );
                    },
                    child: ProjectListItem(
                      index: index + 1,
                      name: project.name ?? "Default Name",
                      formattedCode: project.code ?? "Default Code",
                      status: project.status ?? "Default Status",
                      startDate: project.startDate ?? "N/A",
                      endDate: project.endDate ?? "N/A",
                      statusColor: _getStatusColor(project.status ?? "Default Status"),
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
