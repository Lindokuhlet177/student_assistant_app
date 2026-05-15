/**
*Student Numbers:224108179, 222016851, 221030087, 220019475, 223025046, 221008989
*Student Names: JL Davids, VM Malejane, KP Tshabalala, LJ Thabethe, TG Mofokeng, LM Twala
*/

import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';

enum LoginState { idle, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  final _repo = AuthRepository();

  LoginState state = LoginState.idle;
  String errorMessage = '';
  UserProfile? loggedInUser;

  Future<void> login(String email, String password) async {
    state = LoginState.loading;
    errorMessage = '';
    notifyListeners();

    try {
      loggedInUser = await _repo.login(email, password);
      state = LoginState.success;
    } catch (e) {
      state = LoginState.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> logout() async {
    await _repo.logout();
  }
}
