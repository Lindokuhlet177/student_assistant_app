//student member 2 - 224108179

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
