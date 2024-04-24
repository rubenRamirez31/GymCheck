import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Globales extends ChangeNotifier {
  String primerNombre = "";
  String segundoNombre = "";
  String apellidos = "";
  String genero = "";
  String nick = "";
  String correo = "";
  String fotoPerfil = "";
  String idAuth = "";
  int? primerosPasos;
  DateTime? fechaCreacion;
  bool? verificado;

  Future<void> cargarDatosUsuario(String userId) async {
    try {
      // Realiza una consulta en la colección "Usuarios" buscando el documento con el campo 'userIdAuth' igual al ID de usuario
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("Usuarios")
          .where("userIdAuth", isEqualTo: userId)
          .get();

      // Verifica si se encontraron resultados
      if (userSnapshot.docs.isNotEmpty) {
        // Como se espera que solo haya un documento que coincida con el UID, obtenemos el primer documento
        DocumentSnapshot userDoc = userSnapshot.docs.first;

        // Obtén los datos del documento y asígnalos a las variables globales
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        primerNombre = userData['primer_nombre'] ?? "";
        segundoNombre = userData['segundo_nombre'] ?? "";
        apellidos = userData['apellidos'] ?? "";
        genero = userData['genero'] ?? "";
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

        print("Usuario encontrado e informacion cargada correctamente");
        // Notifica a los widgets que dependen de estos datos que necesitan actualizarse
        notifyListeners();
      } else {
        print("No se encontró ningún documento con el UID proporcionado.");
      }
    } catch (error) {
      print("Error al cargar los datos del usuario: $error");
    }
  }
}
