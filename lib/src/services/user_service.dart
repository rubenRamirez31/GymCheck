import 'dart:convert';
import 'package:gym_check/src/environments/environment.dart';
import 'package:gym_check/src/models/user_model.dart';
import 'package:http/http.dart' as http;


class UserService {

  
  

  static Future<Map<String, dynamic>> getUserData(String userId) async {
    String apiUrl = '${Environment.API_URL}/api/users/obtener-by-id/$userId'; // Modifica la URL de la API según tu endpoint

    try {
    
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Si la solicitud fue exitosa, decodifica la respuesta JSON
        final userData = jsonDecode(response.body);
        return userData;
      } else {
        // Si hay un error en la solicitud, lanza una excepción
         print('Error en getUserdata: $userId');
        throw Exception('Error al obtener los datos del usuario: ${response.statusCode}');
      }
    } catch (error) {
      // Si hay un error en la conexión o en la solicitud, lanza una excepción
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<String?> createUser(User user) async {
    String apiUrl = '${Environment.API_URL}/api/users/crear-usuario';

    try {
      String jsonData = jsonEncode(user.toJson());
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonData,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 201) {
        return null; // No hay error
      } else {
        String errorMessage = response.body;
        return errorMessage;
      }
    } catch (error) {
      print('Error en la solicitud: $error');
      return 'Error en la solicitud';
    }
  }
  
static Future<Map<String, dynamic>> updateUser(String userId, User user) async {
  String apiUrl = '${Environment.API_URL}/api/users/actualizar-usuario/$userId';

  try {
    var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));

    // Adjuntar los campos necesarios al formulario
    if (user.verificado != null) {
      request.fields['verificado'] = user.verificado.toString();
    }
    if (user.primerosPasos != null) {
      request.fields['primeros_pasos'] = user.primerosPasos.toString();
    }
    if (user.fotoPerfil != null) {
      var fileStream = http.ByteStream(user.fotoPerfil!.openRead());
      var length = await user.fotoPerfil!.length();
      var multipartFile = http.MultipartFile(
        'fotoPerfil',
        fileStream,
        length,
        filename: user.fotoPerfil!.path.split('/').last,
      );
      request.files.add(multipartFile);
    }
    if (user.email != null) {
      request.fields['email'] = user.email.toString();
    }
    if (user.nick != null) {
      request.fields['nick'] = user.nick.toString();
    }
    if (user.primerNombre != null) {
      request.fields['primer_nombre'] = user.primerNombre.toString();
    }
    if (user.segundoNombre != null) {
      request.fields['segundo_nombre'] = user.segundoNombre.toString();
    }
    if (user.apellidos != null) {
      request.fields['apellidos'] = user.apellidos.toString();
    }
    if (user.genero != null) {
    request.fields['genero'] = user.genero.toString();
    }


    var response = await request.send();

    if (response.statusCode == 200) {
      return {'message': 'Usuario actualizado correctamente'};
    } else {
      String errorMessage = await response.stream.bytesToString();
      return {'error': errorMessage};
    }
  } catch (error) {
    print('Error en la solicitud: $error');
    return {'error': 'Error en la solicitud'};
  }
}


  static Future<List<User>> getAllUsers() async {
    String apiUrl = '${Environment.API_URL}/api/users/obtener-usuarios';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final List<User> users = responseData.map((data) => User.fromJson(data)).toList();
        return users;
      } else {
        throw Exception('Error al obtener todos los usuarios: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<User?> getUserById(String userId) async {
    String apiUrl = '${Environment.API_URL}/api/users/obtener-by-id/$userId';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return User.fromJson(userData);
      } else {
        throw Exception('Error al obtener datos del usuario: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<User?> getUserByNick(String nick) async {
    String apiUrl = '${Environment.API_URL}/api/users/obtener-by-nick/$nick';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body)['user'];
        return User.fromJson(userData);
      } else {
        throw Exception('Error al obtener el usuario por nick: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    String apiUrl = '${Environment.API_URL}/api/users/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userId = responseData['userId'];
        final token = responseData['token'];
        return {'userId': userId, 'token': token};
      } else {
        throw Exception('Inicio de sesión fallido: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<void> logoutUser() async {
    
  }
}
