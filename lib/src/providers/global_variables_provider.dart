import 'package:flutter/material.dart';

// Este archivo define una clase llamada GlobalVariablesProvider que extiende ChangeNotifier,
// que se utiliza para manejar variables globales en la aplicación y notificar a los widgets
// cuando cambian estas variables.

class GlobalVariablesProvider extends ChangeNotifier {
  // Variables, getters y setters para la subpágina de seguimiento
  int _selectedSubPageTracking = 0;
  int get selectedSubPageTracking => _selectedSubPageTracking;
  set selectedSubPageTracking(int newValue) {
    _selectedSubPageTracking = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }


  // Variables, getters y setters para la subpágina de seguimiento físico
  int _selectedMenuOptionTrackingPhysical = 0;
  int get selectedMenuOptionTrackingPhysical => _selectedMenuOptionTrackingPhysical;
  set selectedMenuOptionTrackingPhysical(int newValue) {
    _selectedMenuOptionTrackingPhysical = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }

  // Variables, getters y setters para la subpágina de seguimiento nutricional
  int _selectedMenuOptionNutritional = 0;
  int get selectedMenuOptionNutritional => _selectedMenuOptionNutritional;
  set selectedMenuOptionNutritional(int newValue) {
    _selectedMenuOptionNutritional = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }

  // Variable, getter y setter para la opción de días
  int _selectedMenuOptionDias = 0;
  int get selectedMenuOptionDias => _selectedMenuOptionDias;
  set selectedMenuOptionDias(int newValue) {
    _selectedMenuOptionDias = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }

  ///modulo de creacion

  // Variables, getters y setters para la subpágina de creación
  int _selectedSubPageCreate = 0;
  int get selectedSubPageCreate => _selectedSubPageCreate;
  set selectedSubPageCreate(int newValue) {
    _selectedSubPageCreate = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }


  int _selectedMenuOptionHomeExercise = 0;
  int get selectedMenuOptionHomeExercise => _selectedMenuOptionHomeExercise;
  set selectedMenuOptionHomeExercise(int newValue) {
    _selectedMenuOptionHomeExercise = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }

  int _selectedMenuOptionAllExercise = 0;
  int get selectedMenuOptionAllExercise => _selectedMenuOptionAllExercise;
  set selectedMenuOptionAllExercise(int newValue) {
    _selectedMenuOptionAllExercise = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }

  int _selectedMenuOptionExerciseByFocus = 0;
  int get selectedMenuOptionExerciseByFocus => _selectedMenuOptionExerciseByFocus;
  set selectedMenuOptionExerciseByFocus(int newValue) {
    _selectedMenuOptionExerciseByFocus = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }
}
