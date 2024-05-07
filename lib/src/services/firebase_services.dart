import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/social/post_model.dart';
import 'package:gym_check/src/models/usuario/usuario.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:provider/provider.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

Future<int> crearPost(Post p) async {
  CollectionReference coleccion = db.collection("Publicaciones");
  int codigo = 0;

  try {
    await coleccion.add(p.toJson());
    codigo = 200;
  } catch (e) {
    codigo = 500;
  }

  return codigo;
}

Future<String> login(String correo, String pwd) async {
  try {
    UserCredential credenciales =
        await auth.signInWithEmailAndPassword(email: correo, password: pwd);
    return "200";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
      return "Usuario y/o Contraseña incorrecta";
    } else {
      return e.code;
    }
  }
}

Future<String?> crearUsuario(String correo, String pwd) async {
  try {
    UserCredential credenciales =
        await auth.createUserWithEmailAndPassword(email: correo, password: pwd);

    return credenciales.user?.uid;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      return "Este correo ya esta en uso";
    } else {
      return e.code;
    }
  }
}
 Future<String> updateUser(Map<String, dynamic> newData, BuildContext context) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);

      // Realizar una consulta para encontrar el usuario con el userIdAuth proporcionado
      QuerySnapshot userQuery = await FirebaseFirestore.instance.collection('Usuarios').where('userIdAuth', isEqualTo: globales.idAuth).get();

      // Verificar si se encontró algún usuario
      if (userQuery.docs.isNotEmpty) {
        // Obtener la referencia del documento del usuario
        DocumentReference userRef = FirebaseFirestore.instance.collection('Usuarios').doc(userQuery.docs.first.id);

        // Actualizar el documento del usuario con los nuevos datos
        await userRef.update(newData);
        return "Usuario actualizado correctamente";
      } else {
        return "No se encontró ningún usuario con el userIdAuth proporcionado";
      }
    } catch (error) {
      // Manejar errores
      return "Error: $error";
    }
  }

Future<bool> checkNick(String nick) async {
  try {
    QuerySnapshot userSnapshot = await FirebaseFirestore.instance
        .collection("Usuarios")
        .where("nick", isEqualTo: nick)
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<int> uploadUser(Usuario u) async {
  CollectionReference coleccion = db.collection("Usuarios");
  int codigo = 0;

  try {
    await coleccion.add(u.toJson());
    codigo = 200;
  } catch (e) {
    codigo = 500;
  }

  return codigo;
}
