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
