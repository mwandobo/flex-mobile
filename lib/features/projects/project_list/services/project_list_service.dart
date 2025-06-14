import 'package:flex_mobile/core/api/api_constants.dart';
import '../../../../core/api/api_service.dart';
import '../models/project_list_model.dart';

class ProjectListService {
  Future<(bool, List<ProjectListModel>)> fetchProjects() async {
    final response = await ApiService()
        .request(ApiConstants.get, ApiConstants.projectEndpoint);

    final projectsJson = response['data'];

    List<ProjectListModel> projects = ProjectListModel.projectListFromJson(projectsJson);

    return (true, projects);
  }
}
