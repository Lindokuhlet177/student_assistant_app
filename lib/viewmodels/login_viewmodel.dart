//student member 2 - 224108179

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
