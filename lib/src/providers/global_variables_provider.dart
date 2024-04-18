import 'package:flutter/material.dart';

// Este archivo define una clase llamada GlobalVariablesProvider que extiende ChangeNotifier,
// que se utiliza para manejar variables globales en la aplicación y notificar a los widgets
// cuando cambian estas variables.

class GlobalVariablesProvider extends ChangeNotifier {
  // Variable para guardar el estado de la subpágina en seguimiento
  int _selectedSubPageTracking = 0;

  // Variable para guardar el estado de la subpágina en creación
  int _selectedSubPageCreate = 0;
  
  // Variable para guardar el estado de la última opción seleccionada de la subpágina seguimiento físico
  int _selectedMenuOptionTrackingPhysical = 0;

  // Variable para guardar el estado de la última opción seleccionada de la subpágina seguimiento nutricional
  int _selectedMenuOptionNutritional = 0;

  // Getter para obtener el estado de la subpágina en seguimiento
  int get selectedSubPageTracking => _selectedSubPageTracking;
  // Getter para obtener el estado de la subpágina en creación
  int get selectedSubPageCreate => _selectedSubPageCreate;
  
  // Getter para obtener el estado de la última opción seleccionada de la subpágina en seguimiento físico
  int get selectedMenuOptionTrackingPhysical => _selectedMenuOptionTrackingPhysical;

  // Getter para obtener el estado de la última opción seleccionada de la subpágina en seguimiento nutricional
  int get selectedMenuOptionNutritional => _selectedMenuOptionNutritional;

  // Setter para actualizar el estado de la subpágina en seguimiento y notificar a los listeners
  set selectedSubPageTracking(int newValue) {
    _selectedSubPageTracking = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }
  // Setter para actualizar el estado de la subpágina en creación y notificar a los listeners
  set selectedSubPageCreate(int newValue) {
    _selectedSubPageCreate = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }

  // Setter para actualizar el estado de la última opción seleccionada de la subpágina en seguimiento físico y notificar a los listeners
  set selectedMenuOptionTrackingPhysical(int newValue) {
    _selectedMenuOptionTrackingPhysical = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }

  // Setter para actualizar el estado de la última opción seleccionada de la subpágina en seguimiento nutricional y notificar a los listeners
  set selectedMenuOptionNutritional(int newValue) {
    _selectedMenuOptionNutritional = newValue;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }
}
