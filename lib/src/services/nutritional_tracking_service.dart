import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NutritionalService {



  static Future<Map<String, dynamic>> getTrackingData(BuildContext context) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.nick);
      final docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        return {'trackingData': docSnapshot.data()};
      } else {
        return {'error': 'No se encontraron datos de seguimiento para el usuario'};
      }
    } catch (error) {
      print('Error al obtener datos nutricionales por nick: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

   static Future<Map<String, dynamic>> updateTrackingData(BuildContext context, Map<String, dynamic> newData) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.nick);

      final docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        // Si el documento existe, actualizamos los datos
        await userRef.update(newData);
        return {'message': 'Datos actualizados exitosamente'};
      } else {
        // Si el documento no existe, lo creamos con los nuevos datos
        await userRef.set(newData);
        return {'message': 'Datos creados exitosamente'};
      }
    } catch (error) {
      print('Error al actualizar o crear datos: $error');
      return {'error': 'Error en la solicitud'};
    }
  }



  static Future<Map<String, dynamic>> addNutritionalData(BuildContext context, Map<String, double> data) async {
  try {
    final globales = Provider.of<Globales>(context, listen: false);
    final userCollectionRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.nick);

    final currentDate = DateTime.now();

    // Crear un lote de escritura para guardar los datos de todas las macros
    WriteBatch batch = FirebaseFirestore.instance.batch();

    data.forEach((macro, value) {
      final typeData = macro.toLowerCase();
      final macroData = {
        'tipo': typeData,
        'valor': value,
        'fecha': currentDate,
      };

      final macroRef = userCollectionRef.collection('Registro-Macros').doc();
      batch.set(macroRef, macroData);
    });

    // Ejecutar el lote de escritura
    await batch.commit();

    return {'message': 'Datos de todas las macros agregados exitosamente'};
  } catch (error) {
    print('Error al agregar datos nutricionales: $error');
    return {'error': 'Error en la solicitud'};
  }
}


  static Future<List<Map<String, dynamic>>> getDataWithDynamicSorting(BuildContext context, String collectionType, String orderByTipo, String orderByDirection, String typeData) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.nick).collection('Registro-Macros');

      final querySnapshot = await userCollectionRef.where('tipo', isEqualTo: typeData).orderBy(orderByTipo, descending: orderByDirection == 'desc').get();

      final data = querySnapshot.docs.map((doc) {
        var formattedData = doc.data();
        formattedData['fecha'] = DateFormat('dd-MM-yyyy').format((formattedData['fecha'] as Timestamp).toDate());
        return formattedData;
      }).toList();

      return data;
    } catch (error) {
      print('Error al obtener datos nutricionales con ordenamiento dinámico: $error');
      throw error;
    }
  }

 
  static Future<Map<String, dynamic>> getLatestNutritionalDataV2(BuildContext context, String collection) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance.collection('Nutricion').doc(globales.nick).collection(collection);
      final querySnapshot = await userCollectionRef.orderBy('fecha', descending: true).get();

      // Crear un mapa para almacenar los últimos datos de cada tipo
      Map<String, dynamic> latestDataByType = {};

      // Iterar sobre los documentos para obtener los últimos datos de cada tipo
      querySnapshot.docs.forEach((doc) {
        final latestData = doc.data();
        final tipo = latestData['tipo'];
        if (!latestDataByType.containsKey(tipo)) {
          // Si aún no se ha agregado ningún dato de este tipo, agregarlo al mapa
          final timestamp = (latestData['fecha'] as Timestamp).toDate();
          final formattedDate = DateFormat('dd-MM-yyyy').format(timestamp);
          latestData['fecha'] = formattedDate;
          latestDataByType[tipo] = latestData;
        }
      });

      return latestDataByType;
    } catch (error) {
      print('Error al obtener los últimos datos nutricionales: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<Map<String, dynamic>> updateNutritionalDataByNick(BuildContext context, Map<String, dynamic> nutritionalData) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userRef = FirebaseFirestore.instance.collection('Nutricion').doc(globales.nick);
      await userRef.update(nutritionalData);

      return {'message': 'Configuraciones de NutritionalData actualizadas correctamente'};
    } catch (error) {
      print('Error al actualizar NutritionalData: $error');
      return {'error': 'Error en la solicitud'};
    }
  }
}
