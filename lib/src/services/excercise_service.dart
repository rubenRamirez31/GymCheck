import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:provider/provider.dart';

class ExerciseService {
  static Future<void> agregarEjercicio(BuildContext context, Exercise exercise) async {
    try {
      // Accede a la referencia de la colección "Ejercicios" en Firestore
      final exerciseCollectionRef = FirebaseFirestore.instance.collection('Ejercicios');

      // Convierte el ejercicio a un mapa JSON para guardarlo en Firestore
      final exerciseMap = exercise.toMap();

      // Agrega el ejercicio a Firestore
      await exerciseCollectionRef.add(exerciseMap);

      print('Ejercicio agregado con éxito.');
    } catch (error) {
      print('Error al agregar el ejercicio: $error');
      throw error; // Puedes manejar el error según tus necesidades
    }
  }

//que el tambien optenga el id del documento
static Stream<List<Exercise>> obtenerTodosEjerciciosStream(BuildContext context) {
  final StreamController<List<Exercise>> controller = StreamController<List<Exercise>>();

  try {
    final exerciseCollectionRef = FirebaseFirestore.instance.collection('Ejercicios');
    final StreamSubscription<QuerySnapshot> subscription = exerciseCollectionRef.snapshots().listen((QuerySnapshot snapshot) {
      final List<Exercise> exercises = snapshot.docs.map((DocumentSnapshot doc) {
        final exercise = Exercise.fromFirestore(doc);
        exercise.id = doc.id; // Agregar el ID del documento al modelo Exercise
        return exercise;
      }).toList();
      controller.add(exercises);
    }, onError: (error) {
      print('Error obtaining exercise stream: $error');
      controller.addError(error);
    });

    // Cancela la suscripción cuando se cierre el StreamController
    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  } catch (error) {
    print('Error obtaining exercise stream: $error');
    throw error;
  }
}


   static Future<List<Exercise>> obtenerEjerciciosPorEnfoque(BuildContext context, String enfoque) async {
    try {
      final exerciseCollectionRef = FirebaseFirestore.instance.collection('Ejercicios');
      final querySnapshot = await exerciseCollectionRef.where('primaryFocus', isEqualTo: enfoque).get();
      final exercises = querySnapshot.docs.map((doc) => Exercise.fromFirestore(doc)).toList();
      return exercises;
    } catch (error) {
      print('Error al obtener ejercicios por enfoque: $error');
      throw error;
    }
  }

static Stream<List<Exercise>> obtenerEjerciciosFiltradosStream(BuildContext context, String query) {
  final StreamController<List<Exercise>> controller = StreamController<List<Exercise>>();

  // Accede a la colección "Ejercicios" en Firestore
  final CollectionReference exerciseCollectionRef = FirebaseFirestore.instance.collection('Ejercicios');

  // Crea una consulta que filtre los ejercicios por el término de búsqueda
  final Query filteredQuery = exerciseCollectionRef.where(
    'name',
    isGreaterThanOrEqualTo: query,
    isLessThanOrEqualTo: query + '\uf8ff', // \uf8ff es el último código Unicode
  );

  // Escucha los cambios en la consulta filtrada
  final StreamSubscription<QuerySnapshot> subscription = filteredQuery.snapshots().listen((QuerySnapshot snapshot) {
    final List<Exercise> exercises = snapshot.docs.map((DocumentSnapshot doc) {
      final exercise = Exercise.fromFirestore(doc);
      exercise.id = doc.id; // Agregar el ID del documento al modelo Exercise
      return exercise;
    }).toList();
    controller.add(exercises);
  }, onError: (error) {
    print('Error al obtener ejercicios filtrados: $error');
    controller.addError(error);
  });

  // Cancela la suscripción cuando se cierre el StreamController
  controller.onCancel = () {
    subscription.cancel();
  };

  return controller.stream;
}

static Future<Exercise?> obtenerEjercicioPorId(BuildContext context, String exerciseId) async {
  try {
    final exerciseDoc = await FirebaseFirestore.instance.collection('Ejercicios').doc(exerciseId).get();
    if (exerciseDoc.exists) {
      final exercise = Exercise.fromFirestore(exerciseDoc);
      exercise.id = exerciseDoc.id; // Agregar el ID del documento al modelo Exercise
      return exercise;
    } else {
      return null; // No se encontró el ejercicio con el ID dado
    }
  } catch (error) {
    print('Error obtaining exercise by ID: $error');
    throw error;
  }
}


}
