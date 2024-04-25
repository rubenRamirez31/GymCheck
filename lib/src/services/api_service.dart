import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/models/user_model.dart';

import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../environments/environment.dart';

class ApiService {
  /////////////////////////////red social

  static Future<String?> crearPublicacion(Post post) async {
    String apiUrl = '${Environment.API_URL}/api/social/post/create-post';

    try {
      // Crear un formulario multipart
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Adjuntar los campos de texto al formulario
      request.fields['userId'] = post.userId;
      //request.fields['lugar'] = post.lugar;
      request.fields['texto'] = post.texto;
      request.fields['nick'] = post.nick;

      // Adjuntar el archivo al formulario si está presente
/*     if (post.imagen != null) {
      var fileStream = http.ByteStream(post.imagen!.openRead());
      var length = await post.imagen!.length();
      var multipartFile = http.MultipartFile('imagen', fileStream, length, filename: post.imagen!.path.split('/').last);
      request.files.add(multipartFile);
    } */

      // Enviar la solicitud
      var response = await request.send();

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 201) {
        // Publicación creada exitosamente
        print('Publicación creada correctamente');
        return null; // No hay error
      } else {
        // Error en la solicitud, obtener el mensaje de error de la respuesta si es posible
        String errorMessage = await response.stream.bytesToString();
        return errorMessage;
      }
    } catch (error) {
      // Error de red o en la solicitud
      print('Error en la solicitud: $error');
      return 'Error en la solicitud';
    }
  }

  static Future<List<Post>> getAllPosts() async {
    String apiUrl = '${Environment.API_URL}/api/social/post/get-all';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> postsData = responseData['posts'];
        final List<Post> posts =
            postsData.map((data) => Post.fromJson(data)).toList();
        return posts;
      } else {
        throw Exception(
            'Error al obtener todas las publicaciones: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<List<Post>> getPostsByNick(String nick) async {
    String apiUrl =
        '${Environment.API_URL}/api/social/post/get-posts-by-nick/$nick';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> postsData = responseData['publicaciones'];
        final List<Post> posts =
            postsData.map((data) => Post.fromJson(data)).toList();
        return posts;
      } else {
        throw Exception(
            'Error al obtener las publicaciones por nick: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<List<Post>> getPostsByLugar(String lugar) async {
    String apiUrl =
        '${Environment.API_URL}/api/social/post/get-posts-by-lugar/$lugar';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> postsData = responseData['publicaciones'];
        final List<Post> posts =
            postsData.map((data) => Post.fromJson(data)).toList();
        return posts;
      } else {
        throw Exception(
            'Error al obtener las publicaciones por lugar: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<List<Post>> getPostsByID(String id) async {
    String apiUrl =
        '${Environment.API_URL}/api/social/post/get-posts-by-id/$id';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        final List<Post> posts =
            responseData.map((data) => Post.fromJson(data)).toList();
        return posts;
      } else {
        throw Exception(
            'Error al obtener las publicaciones por ID: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error en la solicitud: $error');
    }
  }

  static Future<String?> editarPublicacion(String postId, Post post) async {
    String apiUrl = '${Environment.API_URL}/api/social/post/editar/$postId';

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        body: jsonEncode({
          'lugar': post.lugar,
          'texto': post.texto,
          // Asegúrate de incluir los demás campos que deseas actualizar
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print('Publicación modificada correctamente');
        return null;
      } else {
        String errorMessage = response.body;
        return errorMessage;
      }
    } catch (error) {
      print('Error en la solicitud: $error');
      return 'Error en la solicitud';
    }
  }
}
