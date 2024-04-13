import 'package:flutter/material.dart';
import 'package:gym_check/src/models/user_sesion_model.dart';

class UserSessionProvider extends ChangeNotifier {
  UserSession? _userSession;

  UserSession? get userSession => _userSession;

  void setUserSession(UserSession userSession) {
    _userSession = userSession;
    notifyListeners();
  }

  void clearUserSession() {
    _userSession = null;
    notifyListeners();
  }

  void logout() {
  clearUserSession();
}

}
