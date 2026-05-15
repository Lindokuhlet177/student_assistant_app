/**
*Student Numbers:224108179, 222016851, 221030087, 220019475, 223025046, 221008989
*Student Names: JL Davids, VM Malejane, KP Tshabalala, LJ Thabethe, TG Mofokeng, LM Twala
*/

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

class AuthRepository {
  final _supabase = Supabase.instance.client;

  Future<UserProfile> login(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final userId = response.user?.id;
    if (userId == null) throw Exception('Login failed');

    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .single();

    return UserProfile.fromMap(data);
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
