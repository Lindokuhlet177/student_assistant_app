/**
*Student Numbers:224108179, 222016851, 221030087, 220019475, 223025046, 221008989
*Student Names: JL Davids, VM Malejane, KP Tshabalala, LJ Thabethe, TG Mofokeng, LM Twala
*/

import 'package:flutter/material.dart';
import '../models/application.dart';
import '../repositories/application_repository.dart';

enum HomeState { idle, loading, loaded, error }

class HomeViewModel extends ChangeNotifier {
  final _repo = ApplicationRepository();

  HomeState state = HomeState.idle;
  List<Application> applications = [];
  String errorMessage = '';

  Future<void> loadApplications() async {
    state = HomeState.loading;
    notifyListeners();

    try {
      applications = await _repo.getStudentApplications();
      state = HomeState.loaded;
    } catch (e) {
      state = HomeState.error;
      errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<void> deleteApplication(String id) async {
    try {
      await _repo.deleteApplication(id);
      await loadApplications();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  bool get hasApplication => applications.isNotEmpty;
}
