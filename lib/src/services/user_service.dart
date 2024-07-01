import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/usuario/usuario.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:provider/provider.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
static Future<String> updateUser(Map<String, dynamic> newData, BuildContext context) async {
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

    // Obtener usuarios filtrados por nickname
  static Stream<List<Usuario>> obtenerUsuariosFiltradosStream(String query) {
    final StreamController<List<Usuario>> controller =
        StreamController<List<Usuario>>();

    final CollectionReference usuarioCollectionRef =
        _firestore.collection('Usuarios');

    // Convertir la consulta a minúsculas
    String lowerCaseQuery = query.toLowerCase();

    // Crear una consulta que filtre los usuarios por el término de búsqueda
    Query filteredQuery = usuarioCollectionRef.where(
      'nick',
      isGreaterThanOrEqualTo: lowerCaseQuery,
      isLessThanOrEqualTo: lowerCaseQuery + '\uf8ff',
    );

    // Escuchar los cambios en la consulta filtrada
    final StreamSubscription<QuerySnapshot> subscription =
        filteredQuery.snapshots().listen((QuerySnapshot snapshot) {
      final List<Usuario> usuarios =
          snapshot.docs.map((DocumentSnapshot doc) {
        final usuario = Usuario.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        return usuario;
      }).toList();
      controller.add(usuarios);
    }, onError: (error) {
      print('Error al obtener usuarios filtrados: $error');
      controller.addError(error);
    });

    // Cancelar la suscripción cuando se cierre el StreamController
    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }

  // Obtener usuario por nickname
  static Future<Usuario?> getUserByNick(String userNick) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Usuarios')
          .where('nick', isEqualTo: userNick)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var doc = querySnapshot.docs.first;
        return Usuario.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Error en getUserByNick: $e');
      return null;
    }
  }

  // Obtener el ID del documento del usuario actual por su ID de autenticación
  static Future<String> getCurrentUserDocId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      QuerySnapshot querySnapshot = await _firestore
          .collection('Usuarios')
          .where('userIdAuth', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.id;
      } else {
        throw Exception('Documento de usuario no encontrado en Firestore');
      }
    } else {
      throw Exception('Usuario no autenticado');
    }
  }

  // Verificar si un usuario sigue a otro
  static Future<bool> isFollowing(String currentUserId, String userIdToCheck) async {
    DocumentSnapshot<Map<String, dynamic>> currentUserSnapshot =
        await _firestore.collection('Usuarios').doc(currentUserId).get();

    if (currentUserSnapshot.exists) {
      var data = currentUserSnapshot.data()!;
      List<String> following = List<String>.from(data['following'] ?? []);
      return following.contains(userIdToCheck);
    }
    return false;
  }

 

  // Obtener seguidores de un usuario
static Stream<List<String>> getFollowers(String userIdDoc) {
  if (userIdDoc.isEmpty) {
    return Stream.value([]); // Retorna un stream vacío si el userIdDoc está vacío
  }
  return _firestore
      .collection('Usuarios')
      .doc(userIdDoc)
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      var followers = data['followers'] ?? [];
      return List<String>.from(followers);
    }
    return [];
  });
}


  // Obtener seguidos de un usuario
  static Stream<List<String>> getFollowing(String userIdDoc) {
    return _firestore
        .collection('Usuarios')
        .doc(userIdDoc)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;
        var following = data['following'] ?? [];
        return List<String>.from(following);
      }
      return [];
    });
  }

  // Obtener usuario por ID de documento
  static Future<Usuario> getUserById(String docId) async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection('Usuarios').doc(docId).get();
    return Usuario.fromFirestore(doc);
  }

  // Seguir a un usuario
  static Future<void> followUser(String currentUserId, String userIdToFollow) async {
    DocumentReference currentUserDoc =
        _firestore.collection('Usuarios').doc(currentUserId);
    DocumentReference userToFollowDoc =
        _firestore.collection('Usuarios').doc(userIdToFollow);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserDoc);
      DocumentSnapshot userToFollowSnapshot = await transaction.get(userToFollowDoc);

      if (currentUserSnapshot.exists && userToFollowSnapshot.exists) {
        var currentUserData = currentUserSnapshot.data() as Map<String, dynamic>;
        var userToFollowData = userToFollowSnapshot.data() as Map<String, dynamic>;

        List<String> currentUserFollowing =
            List<String>.from(currentUserData['following'] ?? []);
        List<String> userToFollowFollowers =
            List<String>.from(userToFollowData['followers'] ?? []);

        if (!currentUserFollowing.contains(userIdToFollow)) {
          currentUserFollowing.add(userIdToFollow);
          userToFollowFollowers.add(currentUserId);

          transaction.update(currentUserDoc, {'following': currentUserFollowing});
          transaction.update(userToFollowDoc, {'followers': userToFollowFollowers});
        }
      }
    });
  }

  // Dejar de seguir a un usuario
  static Future<void> unfollowUser(String currentUserId, String userIdToUnfollow) async {
    DocumentReference currentUserDoc =
        _firestore.collection('Usuarios').doc(currentUserId);
    DocumentReference userToUnfollowDoc =
        _firestore.collection('Usuarios').doc(userIdToUnfollow);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserDoc);
      DocumentSnapshot userToUnfollowSnapshot = await transaction.get(userToUnfollowDoc);

      if (currentUserSnapshot.exists && userToUnfollowSnapshot.exists) {
        var currentUserData = currentUserSnapshot.data() as Map<String, dynamic>;
        var userToUnfollowData = userToUnfollowSnapshot.data() as Map<String, dynamic>;

        List<String> currentUserFollowing =
            List<String>.from(currentUserData['following'] ?? []);
        List<String> userToUnfollowFollowers =
            List<String>.from(userToUnfollowData['followers'] ?? []);

        if (currentUserFollowing.contains(userIdToUnfollow)) {
          currentUserFollowing.remove(userIdToUnfollow);
          userToUnfollowFollowers.remove(currentUserId);

          transaction.update(currentUserDoc, {'following': currentUserFollowing});
          transaction.update(userToUnfollowDoc, {'followers': userToUnfollowFollowers});
        }
      }
    });
  }
}
