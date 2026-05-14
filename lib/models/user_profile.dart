class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final int? yearOfStudy;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.yearOfStudy,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      fullName: map['full_name'],
      email: map['email'],
      role: map['role'],
      yearOfStudy: map['year_of_study'],
    );
  }
}