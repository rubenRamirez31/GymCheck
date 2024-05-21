import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/models/workout_series_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:provider/provider.dart';

class SerieService {
  static Future<void> agregarSerie(
      BuildContext context, WorkoutSeries exercise) async {
    try {
      // Accede a la referencia de la colección "Ejercicios" en Firestore
      final exerciseCollectionRef =
          FirebaseFirestore.instance.collection('Series');

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

  static Stream<List<WorkoutSeries>> obtenerTodasSeriesStream(
      BuildContext context) {
    final StreamController<List<WorkoutSeries>> controller =
        StreamController<List<WorkoutSeries>>();

    try {
      final serieCollectionRef =
          FirebaseFirestore.instance.collection('Series');
      final StreamSubscription<QuerySnapshot> subscription =
          serieCollectionRef.snapshots().listen((QuerySnapshot snapshot) {
        final List<WorkoutSeries> series =
            snapshot.docs.map((DocumentSnapshot doc) {
          final serie = WorkoutSeries.fromFirestore(doc);
          serie.id = doc.id; // Agregar el ID del documento al modelo Serie
          return serie;
        }).toList();
        controller.add(series);
      }, onError: (error) {
        print('Error al obtener serie stream: $error');
        controller.addError(error);
      });

      // Cancela la suscripción cuando se cierre el StreamController
      controller.onCancel = () {
        subscription.cancel();
      };

      return controller.stream;
    } catch (error) {
      print('Error al obtener serie stream: $error');
      throw error;
    }
  }

  static Stream<List<WorkoutSeries>> obtenerSeriesFiltradasStream(
      BuildContext context, String query, bool cradospormi, bool todo,
      {String? enfoque}) {

    final StreamController<List<WorkoutSeries>> controller =
        StreamController<List<WorkoutSeries>>();

    // Accede a la colección "Series" en Firestore
    final CollectionReference serieCollectionRef =
        FirebaseFirestore.instance.collection('Series');

    // Crea una consulta que filtre las series por el término de búsqueda
    Query filteredQuery = serieCollectionRef.where(
      'name',
      isGreaterThanOrEqualTo: query,
      isLessThanOrEqualTo:
          query + '\uf8ff', // \uf8ff es el último código Unicode
    );

    // Si se proporciona el parámetro "enfoque", filtra por ese enfoque
    if (enfoque != null) {
      filteredQuery = filteredQuery.where('primaryFocus', isEqualTo: enfoque);
    }
    // Si se proporciona el parámetro "enfoque", filtra por ese enfoque
    if (cradospormi == true) {
       Globales globales = Provider.of<Globales>(context, listen: false);
      filteredQuery = filteredQuery.where('nick', isEqualTo: globales.nick);
    }
    // Si se proporciona el parámetro "enfoque", filtra por ese enfoque
    if (todo == true) {
      
      filteredQuery = filteredQuery.where('isPublic', isEqualTo: true);
    }

    // Escucha los cambios en la consulta filtrada
    final StreamSubscription<QuerySnapshot> subscription =
        filteredQuery.snapshots().listen((QuerySnapshot snapshot) {
      final List<WorkoutSeries> series =
          snapshot.docs.map((DocumentSnapshot doc) {
        final serie = WorkoutSeries.fromFirestore(doc);
        serie.id = doc.id; // Agregar el ID del documento al modelo Serie
        return serie;
      }).toList();
      controller.add(series);
    }, onError: (error) {
      print('Error al obtener series filtradas: $error');
      controller.addError(error);
    });

    // Cancela la suscripción cuando se cierre el StreamController
    controller.onCancel = () {
      subscription.cancel();
    };

    return controller.stream;
  }

  static Future<WorkoutSeries?> obtenerSeriePorId(
      BuildContext context, String serieId) async {
    try {
      final serieDoc = await FirebaseFirestore.instance
          .collection('Series')
          .doc(serieId)
          .get();
      if (serieDoc.exists) {
        final serie = WorkoutSeries.fromFirestore(serieDoc);
        serie.id = serieDoc.id; // Agregar el ID del documento al modelo Serie
        return serie;
      } else {
        return null; // No se encontró la serie con el ID dado
      }
    } catch (error) {
      print('Error obtaining serie by ID: $error');
      throw error;
    }
  }


  // Método para modificar la visibilidad de una serie
  static Future<void> modificarVisibilidadSerie(BuildContext context, String serieId, bool esPublica) async {
    try {
      final serieDoc = FirebaseFirestore.instance.collection('Series').doc(serieId);
      await serieDoc.update({'isPublic': esPublica});
      print('Visibilidad de la serie modificada exitosamente.');
    } catch (error) {
      print('Error al modificar la visibilidad de la serie: $error');
      throw error;
    }
  }
}
