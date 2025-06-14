import 'package:flex_mobile/core/constants/colors.dart';
import 'package:flex_mobile/features/project/model/project-model.dart';
import 'package:flex_mobile/features/project/project-status-card-count.dart';
import 'package:flex_mobile/features/project/services/project-service.dart';
import 'package:flex_mobile/features/project/widget/action-row.dart';
import 'package:flex_mobile/features/project/widget/recent-activities.dart';
import 'package:flex_mobile/features/project/widget/upcoming-deadline.dart';
import 'package:flex_mobile/features/project/widget/welcome-header.dart';
import 'package:flutter/material.dart';
import '../../core/utils/error_handler.dart';
import '../../core/widgets/dialog/custom-error-dialog.dart';

class ProjectDashboard extends StatefulWidget {
  const ProjectDashboard({super.key});

  @override
  _ProjectDashboardState createState() => _ProjectDashboardState();
}

class _ProjectDashboardState extends State<ProjectDashboard> {
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
      final (success, List<ProjectModel> _projects) =
          await _projectService.fetchProjects();

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
      CustomErrorDialog.showToast("Failed", ErrorHandler.handle(e), context);
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: WelcomeHeader()),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: projectStatuses.map((status) {
                    return ProjectStatusCardCount(
                      icon: status['icon'] is IconData
                          ? status['icon'] as IconData
                          : Icons.help_outline,
                      title: status['title'],
                      borderColor: status['borderColor'],
                      count: _countProjectsByStatus(status['status']),
                    );
                  }).toList()),
            ),
            const SizedBox(height:  16),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    UpcomingDeadlineCard(),
                    const SizedBox(
                      height: 16,
                    ),
                    RecentActivitiesCard(),
                    const SizedBox(
                      height: 16,
                    ),
                    ActionRow()
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
