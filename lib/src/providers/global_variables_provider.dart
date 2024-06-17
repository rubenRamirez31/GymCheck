import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalVariablesProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  GlobalVariablesProvider() {
    _initSharedPreferences();
  }

  // Inicializa SharedPreferences
  void _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    // Carga los valores guardados de SharedPreferences si existen
    _selectedSubPageTracking = _prefs.getInt('selectedSubPageTracking') ?? 0;

    _selectedMenuOptionTrackingPhysical = _prefs.getInt('selectedMenuOptionTrackingPhysical') ?? 0;
    _selectedMenuOptionTrackingNutritional = _prefs.getInt('selectedMenuOptionTrackingNutritional') ?? 0;
    _selectedMenuOptionTrackingProductivity = _prefs.getInt('selectedMenuOptionTrackingProductivity') ?? 0;

    _selectedMenuOptionDias = _prefs.getInt('selectedMenuOptionDias') ?? 0;
    _selectedSubPageCreate = _prefs.getInt('selectedSubPageCreate') ?? 0;
    _selectedMenuOptionHomeExercise =
        _prefs.getInt('selectedMenuOptionHomeExercise') ?? 0;
    _selectedMenuOptionAllExercise =
        _prefs.getInt('selectedMenuOptionAllExercise') ?? 0;
    _selectedMenuOptionExerciseByFocus =
        _prefs.getInt('selectedMenuOptionExerciseByFocus') ?? 0;
  }

  int _selectedSubPageTracking = 0;
  int get selectedSubPageTracking => _selectedSubPageTracking;
  set selectedSubPageTracking(int newValue) {
    _selectedSubPageTracking = newValue;
    _prefs.setInt(
        'selectedSubPageTracking', newValue); // Guarda en SharedPreferences
    notifyListeners();
  }

  int _selectedMenuOptionTrackingPhysical = 0;
  int get selectedMenuOptionTrackingPhysical =>
      _selectedMenuOptionTrackingPhysical;
  set selectedMenuOptionTrackingPhysical(int newValue) {
    _selectedMenuOptionTrackingPhysical = newValue;
    _prefs.setInt('selectedMenuOptionTrackingPhysical', newValue);
    notifyListeners();
  }

int _selectedMenuOptionTrackingNutritional = 0;
int get selectedMenuOptionTrackingNutritional => _selectedMenuOptionTrackingNutritional;
set selectedMenuOptionTrackingNutritional(int newValue) {
  _selectedMenuOptionTrackingNutritional = newValue;
  _prefs.setInt('selectedMenuOptionTrackingNutritional', newValue);
  notifyListeners();
}


  int _selectedMenuOptionTrackingProductivity = 0;
  int get selectedMenuOptionTrackingProductivity =>
      _selectedMenuOptionTrackingProductivity;

  set selectedMenuOptionTrackingProductivity(int newValue) {
    _selectedMenuOptionTrackingProductivity = newValue;
    _prefs.setInt('selectedMenuOptionTrackingProductivity', newValue);
    notifyListeners();
  }

  int _selectedMenuOptionDias = 0;
  int get selectedMenuOptionDias => _selectedMenuOptionDias;
  set selectedMenuOptionDias(int newValue) {
    _selectedMenuOptionDias = newValue;
    _prefs.setInt('selectedMenuOptionDias', newValue);
    notifyListeners();
  }

  int _selectedSubPageCreate = 0;
  int get selectedSubPageCreate => _selectedSubPageCreate;
  set selectedSubPageCreate(int newValue) {
    _selectedSubPageCreate = newValue;
    _prefs.setInt('selectedSubPageCreate', newValue);
    notifyListeners();
  }

  int _selectedMenuOptionHomeExercise = 0;
  int get selectedMenuOptionHomeExercise => _selectedMenuOptionHomeExercise;
  set selectedMenuOptionHomeExercise(int newValue) {
    _selectedMenuOptionHomeExercise = newValue;
    _prefs.setInt('selectedMenuOptionHomeExercise', newValue);
    notifyListeners();
  }

  int _selectedMenuOptionAllExercise = 0;
  int get selectedMenuOptionAllExercise => _selectedMenuOptionAllExercise;
  set selectedMenuOptionAllExercise(int newValue) {
    _selectedMenuOptionAllExercise = newValue;
    _prefs.setInt('selectedMenuOptionAllExercise', newValue);
    notifyListeners();
  }

  int _selectedMenuOptionExerciseByFocus = 0;
  int get selectedMenuOptionExerciseByFocus =>
      _selectedMenuOptionExerciseByFocus;
  set selectedMenuOptionExerciseByFocus(int newValue) {
    _selectedMenuOptionExerciseByFocus = newValue;
    _prefs.setInt('selectedMenuOptionExerciseByFocus', newValue);
    notifyListeners();
  }
}
