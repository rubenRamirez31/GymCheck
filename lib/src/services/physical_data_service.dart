import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhysicalDataService {

 static Future<Map<String, dynamic>> createPhysicalData(BuildContext context) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance.collection('Seguimiento');

    // Crear un nuevo documento con el mismo nombre que el nick del usuario
    final userDocRef = userCollectionRef.doc(globales.idAuth);
    await userDocRef.set({'meta': '', 'diaFrecuencia': ''});

       // Crear las subcolecciones para los diferentes tipos de datos físicos
    final subCollections = [
      "Registro-Corporal",

      // Agrega aquí más subcolecciones si es necesario
    ];

    // Agregar un dato inicial a cada subcolección
    await Future.forEach(subCollections, (subCollection) async {
      final subCollectionRef = userDocRef.collection(subCollection);
      await subCollectionRef.add({'valor': '', 'fecha': ''});
    });


      return {'message': 'Datos físicos creados exitosamente'};
    } catch (error) {
      print('Error al crear datos físicos: $error');
      return {'error': 'Error en la solicitud'};
    }
  }



  static Future<Map<String, dynamic>> getPhysicalDataByNick(BuildContext context) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.idAuth);
      final docSnapshot = await userRef.get();

      if (docSnapshot.exists) {
        return {'physicalData': docSnapshot.data()};
      } else {
        return {'error': 'No se encontraron datos físicos para el usuario'};
      }
    } catch (error) {
      print('Error al obtener datos físicos por nick: $error');
      return {'error': 'Error en la solicitud'};
    }
  }


  static Future<Map<String, dynamic>> addData(BuildContext context,String collection, Map<String, dynamic> data) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.idAuth).collection(collection);
      final typeData = data['tipo'];
      final currentDate = DateTime.now();
      data['fecha'] = currentDate;
      data[typeData] = data['valor'];

      await userCollectionRef.add(data);

      return {'message': 'Dato $collection agregado exitosamente'};
    } catch (error) {
      print('Error al agregar dato: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<List<Map<String, dynamic>>> getDataWithDynamicSorting(BuildContext context,String collectionType, String orderByTipo, String orderByDirection, String typeData) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.idAuth).collection(collectionType);
      
      final querySnapshot = await userCollectionRef.where('tipo', isEqualTo: typeData).orderBy(orderByTipo, descending: orderByDirection == 'desc').get();
      
      final data = querySnapshot.docs.map((doc) {
        var formattedData = doc.data();
        formattedData['fecha'] = DateFormat('dd-MM-yyyy').format((formattedData['fecha'] as Timestamp).toDate()); 
        return formattedData;
      }).toList();
      
      return data;
    } catch (error) {
      print('Error al obtener datos físicos con ordenamiento dinámico: $error');
      throw error;
    }
  }



    static Future<Map<String, dynamic>> getLatestPhysicalData(BuildContext context,String collection, String typeData) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userCollectionRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.idAuth).collection(collection);
      final querySnapshot = await userCollectionRef.where('tipo', isEqualTo: typeData).orderBy('fecha', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        final latestData = querySnapshot.docs.first.data();
        final timestamp = (latestData['fecha'] as Timestamp).toDate();
        final formattedDate = DateFormat('dd-MM-yyyy').format(timestamp);
        latestData['fecha'] = formattedDate;

        return latestData;
      } else {
        return {}; 
      }
    } catch (error) {
      print('Error al obtener el último dato físico: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<Map<String, dynamic>> getLatestPhysicalDataV2(BuildContext context, String collection) async {
  try {
    final globales = Provider.of<Globales>(context, listen: false);
    final userCollectionRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.idAuth).collection(collection);
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
    print('Error al obtener los últimos datos físicos: $error');
    return {'error': 'Error en la solicitud'};
  }
}


  static Future<Map<String, dynamic>> updatePhysicalDataByNick(BuildContext context,Map<String, dynamic> physicalData) async {
    try {
      final globales = Provider.of<Globales>(context, listen: false);
      final userRef = FirebaseFirestore.instance.collection('Seguimiento').doc(globales.idAuth);
      await userRef.update(physicalData);

      return {'message': 'Configuraciones de PhysicalData actualizadas correctamente'};
    } catch (error) {
      print('Error al actualizar PhysicalData: $error');
      return {'error': 'Error en la solicitud'};
    }
  }
}
