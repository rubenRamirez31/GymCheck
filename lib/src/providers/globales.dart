import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/services/user_service.dart'; // Importa el servicio de usuario

class Globales extends ChangeNotifier {
  String primerNombre = "";
  String segundoNombre = "";
  String apellidos = "";
  String genero = "";
  int edad = 0;
  String nick = "";
  String correo = "";
  String fotoPerfil = "";
  String idAuth = "";
  String idDocumento = ""; // Nuevo campo para el ID del documento del usuario
  int? primerosPasos;
  DateTime? fechaCreacion;
  bool? verificado;
  List<Workout> rutinas = [];
  List<String>? followers;
  List<String>? following;
  String? estado;

  void agregarRutina(Workout w) {
    rutinas.add(w);
    notifyListeners();
  }

  void quitarRutina() {
    rutinas = [];
    notifyListeners();
  }

  Future<void> cargarDatosUsuario(String userId) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Usuarios")
          .where("userIdAuth", isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        idDocumento = userDoc.id; // Guarda el ID del documento del usuario
        primerNombre = userData['primer_nombre'] ?? "";
        segundoNombre = userData['segundo_nombre'] ?? "";
        apellidos = userData['apellidos'] ?? "";
        genero = userData['genero'] ?? "";
        edad = userData['edad'];
        nick = userData['nick'] ?? "";
        correo = userData['email'] ?? "";
        fotoPerfil = userData['urlImagen'] ?? "";
        idAuth = userData['userIdAuth'] ?? "";
        primerosPasos = userData['primeros_pasos'] ?? null;
        fechaCreacion = userData['fechaCreacion'] != null
            ? DateTime.fromMillisecondsSinceEpoch(
                userData['fechaCreacion'].seconds * 1000)
            : null;
        verificado = userData['verificado'] ?? null;
        followers = List<String>.from(userData['followers'] ?? []);
        following = List<String>.from(userData['following'] ?? []);
        estado = (userData['estado'] ?? '');

        print("Usuario encontrado e información cargada correctamente");
        notifyListeners();
      } else {
        print("No se encontró ningún documento con el UID proporcionado.");
      }
    } catch (error) {
      print("Error al cargar los datos del usuario: $error");
    }
  }

  Future<void> followUser(String userIdToFollow) async {
    try {
      await UserService.followUser(
          idDocumento, userIdToFollow); // Usa idDocumento en lugar de idAuth
      notifyListeners();
    } catch (e) {
      print('Error siguiendo al usuario: $e');
    }
  }

  Future<void> unfollowUser(String userIdToUnfollow) async {
    try {
      await UserService.unfollowUser(
          idDocumento, userIdToUnfollow); // Usa idDocumento en lugar de idAuth
      notifyListeners();
    } catch (e) {
      print('Error dejando de seguir al usuario: $e');
    }
  }

  Stream<List<String>> getFollowers() {
    return UserService.getFollowers(
        idDocumento); // Usa idDocumento en lugar de idAuth
  }

  Stream<List<String>> getFollowing() {
    return UserService.getFollowing(
        idDocumento); // Usa idDocumento en lugar de idAuth
  }
}
