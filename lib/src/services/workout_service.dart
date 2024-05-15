import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/models/workout_model.dart';


class RutinaService {
  static Future<void> agregarRutina(BuildContext context, Workout rutina) async {
    try {
      // Accede a la referencia de la colección "Rutinas" en Firestore
      final rutinaCollectionRef = FirebaseFirestore.instance.collection('Rutinas');

      // Convierte la serie a un mapa JSON para guardarlo en Firestore
      final serieMap = rutina.toMap();

      // Agrega la serie a Firestore
      await rutinaCollectionRef.add(serieMap);

      print('Serie agregada con éxito.');
    } catch (error) {
      print('Error al agregar la serie: $error');
      throw error; // Puedes manejar el error según tus necesidades
    }
  }

 static Stream<List<Workout>> obtenerRutinasFiltradasStream(BuildContext context, String query) {
    final StreamController<List<Workout>> controller = StreamController<List<Workout>>();

    // Accede a la colección "Rutinas" en Firestore
    final CollectionReference rutinasCollectionRef = FirebaseFirestore.instance.collection('Rutinas');

    // Crea una consulta que filtre las rutinas por el término de búsqueda
    final Query filteredQuery = rutinasCollectionRef.where(
      'name',
      isGreaterThanOrEqualTo: query,
      isLessThanOrEqualTo: query + '\uf8ff', // \uf8ff es el último código Unicode
    );

    // Escucha los cambios en la consulta filtrada
    final StreamSubscription<QuerySnapshot> subscription = filteredQuery.snapshots().listen((QuerySnapshot snapshot) {
      final List<Workout> rutinas = snapshot.docs.map((DocumentSnapshot doc) {
        final rutina = Workout.fromFirestore(doc);
        rutina.id = doc.id; // Agregar el ID del documento al modelo Workout
        return rutina;
      }).toList();
      controller.add(rutinas);
    }, onError: (error) {
      print('Error al obtener rutinas filtradas: $error');
      controller.addError(error);
    });

    // Cancela la suscripción cuando se cierre el StreamController
    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }

  static Stream<List<Workout>> obtenerTodasRutinasStream(BuildContext context) {
    final StreamController<List<Workout>> controller = StreamController<List<Workout>>();

    try {
      final workoutCollectionRef = FirebaseFirestore.instance.collection('Rutinas');
      final StreamSubscription<QuerySnapshot> subscription = workoutCollectionRef.snapshots().listen((QuerySnapshot snapshot) {
        final List<Workout> workouts = snapshot.docs.map((DocumentSnapshot doc) {
          final workout = Workout.fromMap(doc.data() as Map<String, dynamic>);
          workout.id = doc.id; // Agregar el ID del documento al modelo Workout
          return workout;
        }).toList();
        controller.add(workouts);
      }, onError: (error) {
        print('Error al obtener stream de rutinas: $error');
        controller.addError(error);
      });

      // Cancela la suscripción cuando se cierre el StreamController
      controller.onCancel = () {
        subscription.cancel();
      };

      return controller.stream;
    } catch (error) {
      print('Error al obtener stream de rutinas: $error');
      throw error;
    }
  }

  static Future<Workout?> obtenerRutinaPorId(BuildContext context, String rutinaId) async {
    try {
      final rutinaDoc = await FirebaseFirestore.instance.collection('Rutinas').doc(rutinaId).get();
      if (rutinaDoc.exists) {
        final rutina = Workout.fromFirestore(rutinaDoc);
        rutina.id = rutinaDoc.id; // Agregar el ID del documento al modelo Workout
        return rutina;
      } else {
        return null; // No se encontró la rutina con el ID dado
      }
    } catch (error) {
      print('Error al obtener rutina por ID: $error');
      throw error;
    }
  }

}
