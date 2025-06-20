import 'package:flex_mobile/core/constants/colors.dart';
import 'package:flex_mobile/features/project/project-status-card-count.dart';
import 'package:flex_mobile/features/dashboard/widget/action-row.dart';
import 'package:flex_mobile/features/dashboard/widget/recent-activities.dart';
import 'package:flex_mobile/features/dashboard/widget/upcoming-deadline.dart';
import 'package:flex_mobile/features/dashboard/widget/welcome-header.dart';
import 'package:flex_mobile/features/projects/project_list/models/project_list_model.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_string.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../projects/project_list/services/project_list_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // final ProjectService _projectService = ProjectService();

  List<ProjectListModel> projects = [];
  bool isLoading = false;
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
      'route': '/projects'
    },
    {
      'icon': Icons.check_circle,
      'title': 'Completed',
      'borderColor': AppColors.green,
      'status': 'completed',
      'route': '/projects'
    },
    {
      'icon': Icons.access_alarm,
      'title': 'In Progress',
      'borderColor': AppColors.amber,
      'status': 'on_progress',
      'route': '/projects'
    },
    {
      'icon': Icons.cancel,
      'title': 'Overdue',
      'borderColor': AppColors.red,
      'status': 'overdue',
      'route': '/projects'
    },
  ];

  Future<void> _fetchProjects() async {
    final (success, fetchedProjects) =
    await ProjectListService().fetchProjects();
    if (success) {
      setState(() {
        projects = fetchedProjects;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        errorMessage = "Error fetching projects.";
      });
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

    return
      Scaffold(
        backgroundColor: AppColors.newPrimaryColor,
        appBar:
        AppBar(
          backgroundColor: AppColors.newPrimaryColor,
          automaticallyImplyLeading: false,
          title:  const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Dashboard',
              style:TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontFamily: AppStrings.fontFamilyKent,
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              // Space on the right side
              child: Row(
                children: [
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 4),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(
                  //       Icons.notifications,
                  //       color: AppColors.primary,
                  //       size: 32,
                  //     ),
                  //     onPressed: () {},
                  //     splashRadius: 20,
                  //   ),
                  // ),

                  IconButton(
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {},
                    splashRadius: 20,
                  ),
                ],
              ),
            ),
          ],
        ),

    body:  SafeArea(
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
                      route:status['route'] ,
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
                      height: 24,
                    ),
                    RecentActivitiesCard(),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    // ActionRow()
                  ],
                ))
          ],
        ),
      ),
      ),
    );
  }
}
