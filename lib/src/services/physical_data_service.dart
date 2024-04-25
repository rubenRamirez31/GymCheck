import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PhysicalDataService {
  static Future<Map<String, dynamic>> createPhysicalData(String nick) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick);

      await userRef.set({
        'meta': '',
        'diaFrecuencia': '',
      });

      return {'message': 'Datos físicos creados exitosamente'};
    } catch (error) {
      print('Error al crear datos físicos: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<Map<String, dynamic>> getPhysicalDataByNick(String nick) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick);
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

  static Future<Map<String, dynamic>> addData(String nick, String collection, Map<String, dynamic> data) async {
    try {
      final userCollectionRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick).collection(collection);
      final typeData = data['tipo'];
     final currentDate = DateTime.now();
      //final formattedDate = DateFormat('dd-MM-yyyy').format(currentDate); // Formatear la fecha como "yyyy-MM-dd"
      data['fecha'] = currentDate;
      data[typeData] = data['valor'];

      await userCollectionRef.add(data);

      return {'message': 'Dato $collection agregado exitosamente'};
    } catch (error) {
      print('Error al agregar dato: $error');
      return {'error': 'Error en la solicitud'};
    }
  }
static Future<List<Map<String, dynamic>>> getDataWithDynamicSorting(String nick, String collectionType, String orderByTipo, String orderByDirection, String typeData) async {
  try {
    final userCollectionRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick).collection(collectionType);
    
    final querySnapshot = await userCollectionRef.where('tipo', isEqualTo: typeData).orderBy(orderByTipo, descending: orderByDirection == 'desc').get();
    
    final data = querySnapshot.docs.map((doc) {
      var formattedData = doc.data();
      // Formatear la fecha como 'dd-MM-yyyy'
      formattedData['fecha'] = DateFormat('dd-MM-yyyy').format((formattedData['fecha'] as Timestamp).toDate()); 
      return formattedData;
    }).toList();
    
    return data;
  } catch (error) {
    print('Error al obtener datos físicos con ordenamiento dinámico: $error');
    throw error;
  }
}


static Future<Map<String, dynamic>> getLatestPhysicalData(String nick, String collection, String typeData) async {
  try {
    final userCollectionRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick).collection(collection);
    final querySnapshot = await userCollectionRef.where('tipo', isEqualTo: typeData).orderBy('fecha', descending: true).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      final latestData = querySnapshot.docs.first.data();
      final timestamp = (latestData['fecha'] as Timestamp).toDate();
      final formattedDate = DateFormat('dd-MM-yyyy').format(timestamp); // Formatear la fecha como "yyyy-MM-dd"
      latestData['fecha'] = formattedDate;

      return latestData;
    } else {
      return {}; // Si no hay datos, devolver un objeto vacío
    }
  } catch (error) {
    print('Error al obtener el último dato físico: $error');
    return {'error': 'Error en la solicitud'};
  }
}

  static Future<Map<String, dynamic>> updatePhysicalDataByNick(String nick, Map<String, dynamic> physicalData) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick);
      await userRef.update(physicalData);

      return {'message': 'Configuraciones de PhysicalData actualizadas correctamente'};
    } catch (error) {
      print('Error al actualizar PhysicalData: $error');
      return {'error': 'Error en la solicitud'};
    }
  }
}
