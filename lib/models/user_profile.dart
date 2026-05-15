/**
*Student Numbers:224108179, 222016851, 221030087, 220019475, 223025046, 221008989
*Student Names: JL Davids, VM Malejane, KP Tshabalala, LJ Thabethe, TG Mofokeng, LM Twala
*/

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
