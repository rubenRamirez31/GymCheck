
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingFunctions {
  // Esta función carga el valor de la opción de menú seleccionada desde SharedPreferences
  // Parámetros:
  // - value: La clave de SharedPreferences que se usará para buscar el valor
  // - defaultValue: El valor predeterminado que se utilizará si no se encuentra ningún valor almacenado
  // - currentSelectedOption: El valor actual de _selectedMenuOption que se actualizará con el valor obtenido

  static Future<int> loadSelectedMenuOption(
      String value, int defaultValue, int currentSelectedOption) async {
    // Obtener la instancia de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Obtener el valor almacenado en SharedPreferences con la clave 'value'
    // Si no se encuentra ningún valor, se utilizará el 'defaultValue'
    int selectedOption = prefs.getInt(value) ?? defaultValue;

    // Actualizar el valor de 'currentSelectedOption' con el valor obtenido de SharedPreferences
    currentSelectedOption = selectedOption;

    // Devolver el valor actualizado de 'currentSelectedOption'
    return currentSelectedOption;
  }

   static String formatDateTime(String? dateTimeString) {
    if (dateTimeString != null && dateTimeString.isNotEmpty) {
      try {
        DateTime dateTime = DateTime.parse(dateTimeString);
        String formattedDate =
            //DateFormat('dd \'de\' MMMM \'a las\' hh:mm a', 'es')
              //  .format(dateTime);
            DateFormat(' hh:mm a', 'es')
                .format(dateTime);
        return formattedDate;
      } catch (error) {
        print('Error al formatear la fecha: $error');
      }
    }
    return 'Fecha no válida';
  }



  ///Funciones crud para los recordatorios
  
}

