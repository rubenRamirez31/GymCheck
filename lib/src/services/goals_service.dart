import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/meta_diaria_model.dart';
import 'package:gym_check/src/models/meta_principal_model.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GoalsService {
  static Future<void> agregarMetaPrincipal(
      BuildContext context, MetaPrincipal meta) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(globales.nick)
          .collection("Metas");

      // Convierte la MetaPrincipal a un mapa JSON para guardarla en Firestore
      final metaJson = meta.toJson();

      // Agrega la meta principal a Firestore
      await userCollectionRef.add(metaJson);

      print('Meta principal agregada con éxito.');
    } catch (error) {
      print('Error al agregar la meta principal: $error');
      throw error; // Puedes manejar el error según tus necesidades
    }
  }

  static Future<void> agregarMetasDiarias(
      BuildContext context, Map<String, dynamic> metasDiarias) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(globales.nick)
          .collection("Metas");

      await userCollectionRef.add(metasDiarias);

      // Si es necesario, puedes agregar lógica adicional después de agregar las metas diarias
    } catch (error) {
      // Manejo de errores
      print('Error al agregar metas diarias: $error');
    }
  }

  static Future<void> modificarMetaPrincipal(
      BuildContext context, String idMeta, Map<String, dynamic> cambios) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(globales.nick)
          .collection("Metas");

      // Actualiza la meta principal en Firestore
      await userCollectionRef.doc(idMeta).update(cambios);

      print('Meta principal modificada con éxito.');
    } catch (error) {
      print('Error al modificar la meta principal: $error');
      throw error; // Puedes manejar el error según tus necesidades
    }
  }

  static Future<Map<String, dynamic>> obtenerMetaPrincipalActiva(
      BuildContext context) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(globales.nick)
          .collection("Metas");
      final querySnapshot = await userCollectionRef
          .where('tipo', isEqualTo: 'Principal')
          .where('activa', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final metaDoc = querySnapshot.docs.first;
        final meta = metaDoc.data();

        meta['id'] =
            metaDoc.id; // Agregar el ID del documento al mapa de resultados

        return meta;
      } else {
        return {};
      }
    } catch (error) {
      print('Error al obtener la meta principal activa: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<Map<String, dynamic>> obtenerMetaDiariaDeHoy(
      BuildContext context) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(globales.nick)
          .collection("Metas");
      final now = DateTime.now();
      final today = DateTime(
          now.year, now.month, now.day); // Obtener solo la fecha actual

      final querySnapshot = await userCollectionRef
          .where('tipo', isEqualTo: 'Diaria')
          .where('fechaCreacion', isEqualTo: today)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final metaDoc = querySnapshot.docs.first;
        final meta = metaDoc.data();

        meta['id'] =
            metaDoc.id; // Agregar el ID del documento al mapa de resultados

        return meta;
      } else {
        return {};
      }
    } catch (error) {
      print('Error al obtener la meta principal activa: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  //optener meta por tipo y activada en true,

  // Agrega aquí otros métodos para obtener y eliminar metas principales

  //los modelos en la parte de los datos de tiempo hacerlo similiar a lo de remedir
}
