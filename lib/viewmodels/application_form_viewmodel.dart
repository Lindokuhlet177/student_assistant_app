/**
*Student Numbers:224108179, 222016851, 221030087, 220019475, 223025046, 221008989
*Student Names: JL Davids, VM Malejane, KP Tshabalala, LJ Thabethe, TG Mofokeng, LM Twala
*/

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum ApplicationFormStatus { idle, loading, success, error }

class ApplicationFormViewModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  ApplicationFormStatus status = ApplicationFormStatus.idle;
  String errorMessage = '';

  int? yearOfStudy;
  String? module1Level;
  String? module1Name;
  bool addSecondModule = false;
  String? module2Level;
  String? module2Name;
  bool meetsRequirements = false;

  void setYearOfStudy(int? value) { yearOfStudy = value; notifyListeners(); }
  void setModule1Level(String? value) { module1Level = value; notifyListeners(); }
  void setModule1Name(String? value) { module1Name = value; notifyListeners(); }
  void setAddSecondModule(bool value) {
    addSecondModule = value;
    if (!value) { module2Level = null; module2Name = null; }
    notifyListeners();
  }
  void setModule2Level(String? value) { module2Level = value; notifyListeners(); }
  void setModule2Name(String? value) { module2Name = value; notifyListeners(); }
  void setMeetsRequirements(bool value) { meetsRequirements = value; notifyListeners(); }

  Future<void> submitApplication() async {
    status = ApplicationFormStatus.loading;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser!.id;
      await _supabase.from('applications').insert({
        'student_id': userId,
        'year_of_study': yearOfStudy,
        'module_1_level': module1Level,
        'module_1_name': module1Name,
        'module_2_level': addSecondModule ? module2Level : null,
        'module_2_name': addSecondModule ? module2Name : null,
        'meets_requirements': meetsRequirements,
        'status': 'pending',
      });
      status = ApplicationFormStatus.success;
    } catch (e) {
      status = ApplicationFormStatus.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }
}
