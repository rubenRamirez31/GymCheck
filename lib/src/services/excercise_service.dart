import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/models/excercise_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:provider/provider.dart';

class ExerciseService {
  static Future<void> agregarEjercicio(
      BuildContext context, Exercise exercise) async {
    try {
      // Accede a la referencia de la colección "Ejercicios" en Firestore
      final exerciseCollectionRef =
          FirebaseFirestore.instance.collection('Ejercicios');

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

  ///Favoritos
  static Future<void> agregarAFavoritos(
      BuildContext context, Exercise exercise) async {
    try {
      // Obtener el nick del usuario
      Globales globales = Provider.of<Globales>(context, listen: false);
      final nick = globales.nick;

      // Accede a la referencia del documento del usuario en la colección "Mis-Favoritos"
      final userFavoritesDocRef =
          FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);

      // Verifica si el documento del usuario ya existe
      final userDocSnapshot = await userFavoritesDocRef.get();
      if (!userDocSnapshot.exists) {
        // Si el documento del usuario no existe, créalo
        await userFavoritesDocRef.set({});
        print(
            'Se creó el documento del usuario en la colección "Mis-Favoritos".');
      }

      // Accede a la subcolección "Ejercicios" dentro del documento del usuario
      final userExerciseCollectionRef =
          userFavoritesDocRef.collection('Ejercicios');

      // Comprueba si el ejercicio ya está en favoritos
      final existingExercise =
          await userExerciseCollectionRef.doc(exercise.id).get();
      if (existingExercise.exists) {
        // Si el ejercicio ya está en favoritos, no lo agregues nuevamente
        print('Este ejercicio ya está en favoritos.');
        return;
      }

      // Agrega el ejercicio a la subcolección "Ejercicios" del usuario
      await userExerciseCollectionRef.doc(exercise.id).set({
        'id': exercise.id,
        'name': exercise.name,

        // Agrega aquí cualquier otro dato que desees guardar
      });

      print('Ejercicio agregado a favoritos con éxito.');
    } catch (error) {
      print('Error al agregar el ejercicio a favoritos: $error');
      throw error;
    }
  }

  static Future<void> quitarDeFavoritos(
      BuildContext context, String exerciseId) async {
    try {
      // Obtener el nick del usuario
      Globales globales = Provider.of<Globales>(context, listen: false);
      final nick = globales.nick;

      // Accede a la referencia del documento del usuario en la colección "Mis-Favoritos"
      final userFavoritesDocRef =
          FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);

      // Accede a la subcolección "Ejercicios" dentro del documento del usuario
      final userExerciseCollectionRef =
          userFavoritesDocRef.collection('Ejercicios');

      // Comprueba si el ejercicio está en favoritos
      final existingExercise =
          await userExerciseCollectionRef.doc(exerciseId).get();
      if (!existingExercise.exists) {
        // Si el ejercicio no está en favoritos, no es necesario quitarlo
        print('Este ejercicio no está en favoritos.');
        return;
      }

      // Elimina el ejercicio de la subcolección "Ejercicios" del usuario
      await userExerciseCollectionRef.doc(exerciseId).delete();

      print('Ejercicio eliminado de favoritos con éxito.');
    } catch (error) {
      print('Error al quitar el ejercicio de favoritos: $error');
      throw error;
    }
  }

  static Future<bool> esFavorito(
      BuildContext context, String exerciseId) async {
    try {
      // Obtener el nick del usuario
      Globales globales = Provider.of<Globales>(context, listen: false);
      final nick = globales.nick;

      // Acceder al documento del usuario en la colección "Mis-Favoritos"
      final userFavoritesDocRef =
          FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);

      // Acceder a la subcolección "Ejercicios" dentro del documento del usuario
      final userExerciseCollectionRef =
          userFavoritesDocRef.collection('Ejercicios');

      // Verificar si el ejercicio está en la colección de favoritos
      final exerciseDocSnapshot =
          await userExerciseCollectionRef.doc(exerciseId).get();
      return exerciseDocSnapshot.exists;
    } catch (error) {
      print('Error al verificar si el ejercicio es favorito: $error');
      throw error;
    }
  }

  static Stream<List<Exercise>> obtenerTodosEjerciciosStream(
      BuildContext context) {
    final StreamController<List<Exercise>> controller =
        StreamController<List<Exercise>>();

    try {
      final exerciseCollectionRef =
          FirebaseFirestore.instance.collection('Ejercicios');
      final StreamSubscription<QuerySnapshot> subscription =
          exerciseCollectionRef.snapshots().listen((QuerySnapshot snapshot) {
        final List<Exercise> exercises =
            snapshot.docs.map((DocumentSnapshot doc) {
          final exercise = Exercise.fromFirestore(doc);
          exercise.id =
              doc.id; // Agregar el ID del documento al modelo Exercise
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

  static Stream<List<Exercise>> obtenerEjerciciosFiltradosFavoritosStream(
      BuildContext context, String query,
      {String? enfoque}) {
    final StreamController<List<Exercise>> controller =
        StreamController<List<Exercise>>();

    try {
      // Obtener el nick del usuario
      Globales globales = Provider.of<Globales>(context, listen: false);
      final nick = globales.nick;

      // Acceder al documento del usuario en la colección "Mis-Favoritos"
      final userFavoritesDocRef =
          FirebaseFirestore.instance.collection('Mis-Favoritos').doc(nick);

      // Acceder a la subcolección "Ejercicios" dentro del documento del usuario
      final userExerciseCollectionRef =
          userFavoritesDocRef.collection('Ejercicios');

      // Crear una consulta filtrada por el término de búsqueda
      Query filteredQuery = userExerciseCollectionRef.where(
        'name',
        isGreaterThanOrEqualTo: query,
        isLessThanOrEqualTo: query + '\uf8ff',
      );

      

      // Escuchar los cambios en la consulta filtrada
      final StreamSubscription<QuerySnapshot> subscription =
          filteredQuery.snapshots().listen((QuerySnapshot snapshot) async {
          
        final List<Exercise> filteredExercises = [];
        for (final doc in snapshot.docs) {
            
          final exerciseId = doc.id;
          // Obtener el ejercicio completo usando su ID
          final exercise = await obtenerEjercicioPorId(context, exerciseId);
      
          if (exercise != null) {
            // Verificar si el ejercicio coincide con el enfoque deseado
            if (enfoque != null && exercise.primaryFocus == enfoque) {
              filteredExercises.add(exercise);
            } else if (enfoque == null) {
              // Si no se proporciona un enfoque, agregar el ejercicio sin filtrar
              filteredExercises.add(exercise);
            }
          }
        }
        controller.add(filteredExercises);
      }, onError: (error) {
        print('Error al obtener ejercicios filtrados favoritos: $error');
        controller.addError(error);
      });

      // Cancelar la suscripción cuando se cierre el StreamController
      controller.onCancel = () {
        subscription.cancel();
      };

      return controller.stream;
    } catch (error) {
      print('Error al obtener ejercicios filtrados favoritos: $error');
      throw error;
    }
  }

  static Stream<List<Exercise>> obtenerEjerciciosFiltradosStream(
      BuildContext context, String query,
      {String? enfoque}) {
    final StreamController<List<Exercise>> controller =
        StreamController<List<Exercise>>();

    // Accede a la colección "Ejercicios" en Firestore
    final CollectionReference exerciseCollectionRef =
        FirebaseFirestore.instance.collection('Ejercicios');

    // Crea una consulta que filtre los ejercicios por el término de búsqueda
    Query filteredQuery = exerciseCollectionRef.where(
      'name',
      isGreaterThanOrEqualTo: query,
      isLessThanOrEqualTo:
          query + '\uf8ff', // \uf8ff es el último código Unicode
    );

    // Si se proporciona el parámetro "primaryFocus", filtra por ese enfoque
    if (enfoque != null) {
      filteredQuery = filteredQuery.where('primaryFocus', isEqualTo: enfoque);
    }

    // Escucha los cambios en la consulta filtrada
    final StreamSubscription<QuerySnapshot> subscription =
        filteredQuery.snapshots().listen((QuerySnapshot snapshot) {
      final List<Exercise> exercises =
          snapshot.docs.map((DocumentSnapshot doc) {
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

  static Future<Exercise?> obtenerEjercicioPorId(
      BuildContext context, String exerciseId) async {
    try {
      final exerciseDoc = await FirebaseFirestore.instance
          .collection('Ejercicios')
          .doc(exerciseId)
          .get();
      if (exerciseDoc.exists) {
        final exercise = Exercise.fromFirestore(exerciseDoc);
        exercise.id =
            exerciseDoc.id; // Agregar el ID del documento al modelo Exercise
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
