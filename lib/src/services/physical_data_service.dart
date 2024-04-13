import 'dart:convert';
import 'package:gym_check/src/environments/environment.dart';
import 'package:http/http.dart' as http;

class PhysicalDataService {
  // Función para crear datos físicos para un usuario
  static Future<Map<String, dynamic>> createPhysicalData(String nick) async {
    String apiUrl = '${Environment.API_URL}/api/datos-fisicos/crear-coleccion';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, dynamic>{
          'nick': nick,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        return {'message': 'Datos físicos creados exitosamente'};
      } else {
        String errorMessage = response.body;
        return {'error': errorMessage};
      }
    } catch (error) {
      print('Error al crear datos físicos: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  // Función para obtener datos físicos por nick de usuario
  static Future<Map<String, dynamic>> getPhysicalDataByNick(String nick) async {
    String apiUrl = '${Environment.API_URL}/api/datos-fisicos/obtener-coleccion/$nick';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final physicalData = jsonDecode(response.body);
        return {'physicalData': physicalData};
      } else {
        String errorMessage = response.body;
        return {'error': errorMessage};
      }
    } catch (error) {
      print('Error al obtener datos físicos por nick: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  // Función para agregar un dato a la colección correspondiente
  static Future<Map<String, dynamic>> addData(String nick, String collection, Map<String, dynamic> data) async {
    String apiUrl = '${Environment.API_URL}/api/datos-fisicos/add-data';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, dynamic>{
          'nick': nick,
          'coleccion': collection,
          ...data,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        return {'message': 'Dato $collection agregado exitosamente'};
      } else {
        String errorMessage = response.body;
        return {'error': errorMessage};
      }
    } catch (error) {
      print('Error al agregar dato: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  // Función para obtener datos físicos con ordenamiento dinámico
  static Future<Map<String, dynamic>> getDataWithDynamicSorting(String userId, String collectionType, String orderByField, String orderByDirection) async {
    String apiUrl = '${Environment.API_URL}/api/datos-fisicos/obtener-datos/$userId/$collectionType/$orderByField/$orderByDirection';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final formattedData = jsonDecode(response.body);
        return {'formattedData': formattedData};
      } else {
        String errorMessage = response.body;
        return {'error': errorMessage};
      }
    } catch (error) {
      print('Error al obtener datos físicos con ordenamiento dinámico: $error');
      return {'error': 'Error en la solicitud'};
    }
  }
static Future<Map<String, dynamic>> getLatestPhysicalData(String nick, String collection) async {
  String apiUrl = '${Environment.API_URL}/api/datos-fisicos/ultimo-dato/$nick/$collection';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final latestPhysicalData = jsonDecode(response.body);
      return latestPhysicalData;
    } else {
      String errorMessage = response.body;
      return {'error': errorMessage};
    }
  } catch (error) {
    print('Error al obtener el último dato físico: $error');
    return {'error': 'Error en la solicitud'};
  }
}


  // Función para actualizar las configuraciones de los datos físicos por nick de usuario
  static Future<Map<String, dynamic>> updatePhysicalDataByNick(String nick, Map<String, dynamic> physicalData) async {
    String apiUrl = '${Environment.API_URL}/api/datos-fisicos/actualizar-configuraciones/$nick';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode(physicalData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        return {'message': 'Configuraciones de PhysicalData actualizadas correctamente'};
      } else {
        String errorMessage = response.body;
        return {'error': errorMessage};
      }
    } catch (error) {
      print('Error al actualizar PhysicalData: $error');
      return {'error': 'Error en la solicitud'};
    }
  }
}
