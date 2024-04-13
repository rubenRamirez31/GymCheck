import 'package:flutter/material.dart';

// Este archivo define una clase llamada GlobalVariablesProvider que extiende ChangeNotifier,
// que se utiliza para manejar variables globales en la aplicación y notificar a los widgets
// cuando cambian estas variables.

class GlobalVariablesProvider extends ChangeNotifier {
  // Variable para guardar el estado de la subpágina en seguimiento
  int _selectedSubPageTracking = 0;

  // Variable para guardar el estado de la subpágina en creacion
  int _selectedSubPageCreate = 0;
  
  // Variable para guardar el estado de la última opción seleccionada de la subpágina seguimmiento fisico
  int _selectedMenuOptionTrackingPhysical = 0;

  // Getter para obtener el estado de la subpágina en seguimiento
  int get selectedSubPageTracking => _selectedSubPageTracking;
  // Getter para obtener el estado de la subpágina en creacion
  int get selectedSubPageCreate => _selectedSubPageCreate;
  
  // Getter para obtener el estado de la última opción seleccionada de la subpágina en seguimiento
  int get selectedMenuOptionTrackingPhysical => _selectedMenuOptionTrackingPhysical;

  // Setter para actualizar el estado de la subpágina en seguimiento y notificar a los listeners
  set selectedSubPageTracking(int nuevoValor) {
    _selectedSubPageTracking = nuevoValor;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }
  // Setter para actualizar el estado de la subpágina en creacion y notificar a los listeners
  set selectedSubPageCreate(int nuevoValor) {
    _selectedSubPageCreate = nuevoValor;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }

  // Setter para actualizar el estado de la última opción seleccionada de la subpágina en seguimiento y notificar a los listeners
  set selectedMenuOptionTrackingPhysical(int nuevoValor) {
    _selectedMenuOptionTrackingPhysical = nuevoValor;
    notifyListeners(); // Notifica a los widgets que están escuchando los cambios
  }
}
