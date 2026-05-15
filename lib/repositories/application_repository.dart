/**
*Student Numbers:224108179, 222016851, 221030087, 220019475, 223025046, 221008989
*Student Names: JL Davids, VM Malejane, KP Tshabalala, LJ Thabethe, TG Mofokeng, LM Twala
*/

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/application.dart';

class ApplicationRepository {
  final _supabase = Supabase.instance.client;

  Future<List<Application>> getStudentApplications() async {
    final userId = _supabase.auth.currentUser!.id;
    final data = await _supabase
        .from('applications')
        .select()
        .eq('student_id', userId)
        .order('created_at', ascending: false);

    return (data as List).map((e) => Application.fromMap(e)).toList();
  }

  Future<void> deleteApplication(String id) async {
    await _supabase.from('applications').delete().eq('id', id);
  }
}
