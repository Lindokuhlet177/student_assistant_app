class Application {
  final String id;
  final String studentId;
  final int yearOfStudy;
  final String module1Level;
  final String module1Name;
  final String? module2Level;
  final String? module2Name;
  final bool meetsRequirements;
  final String? documentUrl;
  final String status;
  final DateTime createdAt;

  Application({
    required this.id,
    required this.studentId,
    required this.yearOfStudy,
    required this.module1Level,
    required this.module1Name,
    this.module2Level,
    this.module2Name,
    required this.meetsRequirements,
    this.documentUrl,
    required this.status,
    required this.createdAt,
  });

  factory Application.fromMap(Map<String, dynamic> map) {
    return Application(
      id: map['id'],
      studentId: map['student_id'],
      yearOfStudy: map['year_of_study'],
      module1Level: map['module_1_level'],
      module1Name: map['module_1_name'],
      module2Level: map['module_2_level'],
      module2Name: map['module_2_name'],
      meetsRequirements: map['meets_requirements'],
      documentUrl: map['document_url'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}