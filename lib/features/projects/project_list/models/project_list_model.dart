class ProjectListModel {
  final int id;
  final String name;
  final String code;
  final String startDate;
  final String endDate;
  final String status;


  ProjectListModel({
    required this.id,
    required this.name,
    required this.code,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory ProjectListModel.fromJson(Map<String, dynamic> json) {
    return ProjectListModel(
      id: json['id'],
      name: json['name'],
      startDate: json['formatted_start_date'],
      endDate: json['formatted_end_date'],
      code: json['code'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'code': code,
      'status': status,
    };
  }

  static List<ProjectListModel> projectListFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ProjectListModel.fromJson(json)).toList();
  }
}
