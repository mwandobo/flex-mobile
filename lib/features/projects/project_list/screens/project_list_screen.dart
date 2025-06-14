import 'package:flex_mobile/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../models/project_list_model.dart';
import '../services/project_list_service.dart';
import '../widgets/project_card_widget.dart';
import '../widgets/project_list_item_widget.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({Key? key}) : super(key: key);

  @override
  _ProjectListScreenState createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  List<ProjectListModel> projects = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.grey;
      case 'on_progress':
        return Colors.orange;
      case 'completed':
      case 'closed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  int _countProjectsByStatus(String status) {
    return projects
        .where((project) => project.code == status)
        .length; // Or adjust according to your status field
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      // return Center(child: Text(errorMessage!));

      NavigationService.navigateTo(0, '/login');
      return Center(child: Text(errorMessage!));
    }

    return Scaffold(
        backgroundColor: AppColors.newPrimaryColor,
        appBar: const CustomAppBar(title: 'Projects'),
        body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: projects.length,
          itemBuilder: (context, index) {
            final project = projects[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProjectCardWidget(
                        data: null), // Update with actual navigation data
                  ),
                );
              },
              child: ProjectListItemWidget(
                name: project.name,
                formattedCode: project.code,
                status: 'project status',
                // Replace with actual status if available
                startDate: project.startDate,
                endDate: project.endDate,
                index: index + 1,
                statusColor: Colors
                    .green, // Replace with _getStatusColor(project.status) if you have a status field
              ),
            );
          },
        ));
  }

  Widget _buildStatusCard(String title, Color borderColor, int count) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                borderColor.withOpacity(0.1),
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
                    color: borderColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '$count',
                  style: TextStyle(
                    color: borderColor,
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
