class ProjectModel{
  final int id;
  final String name;
  final String code;
  final String startDate;
  final String endDate;
  final String status;

  ProjectModel({
    required this.id,
    required this.name,
    required this.code,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {

    return ProjectModel(
      id: json['id'],
      name: json['name'],
      code: json['name'],
      startDate: json['name'],
      endDate: json['name'],
      status: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'startDate': startDate,
      'endDate': startDate,
      'status': status,
    };
  }

  /// ✅ Static method to parse a list of users
  static List<ProjectModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProjectModel.fromJson(json)).toList();
  }
}