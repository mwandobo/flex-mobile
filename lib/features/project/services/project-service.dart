import 'package:flex_mobile/features/project/model/project-model.dart';

import '../../../core/api/api_constants.dart';
import '../../../core/api/api_service.dart';

class ProjectService{
  Future<(bool, List<ProjectModel>)> fetchProjects() async {

    final response = await ApiService()
        .request(ApiConstants.get, ApiConstants.projectEndpoint);

    print('_projects _projects _projects _projects $response');


    final projectJson = response['data'];
    final project = ProjectModel.fromJsonList(projectJson);

    return (true, project);
  }
}