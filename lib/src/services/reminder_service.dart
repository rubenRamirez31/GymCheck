import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/globales.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class ReminderService {
  static Future<Map<String, dynamic>> createReminder(
      BuildContext context, Map<String, dynamic> reminder) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(nick)
          .collection('Recordatorios');
      await userCollectionRef.add(reminder);
      return {'message': 'Recordatorio creado exitosamente'};
    } catch (error) {
      print('Error al crear recordatorio: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<Map<String, dynamic>> createReminderClonado(
      BuildContext context, Map<String, dynamic> reminder) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(nick)
          .collection('Recordatorios');
      await userCollectionRef.add(reminder);
      return {'message': 'Recordatorio creado exitosamente'};
    } catch (error) {
      print('Error al crear recordatorio: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<List<Map<String, dynamic>>> getPrimeReminders(
      BuildContext context) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(nick)
          .collection('Recordatorios');
      final querySnapshot = await userCollectionRef
          .where('modelo', isEqualTo: 'Prime')
          .orderBy('startTime')
          .get();

      final primeReminders = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        // Convertir las cadenas de texto de startTime y endTime a objetos DateTime
        //data['startTime'] = DateTime.parse(data['startTime']);
        //data['endTime'] = DateTime.parse(data['endTime']);
        // Agregar el ID del documento al mapa de datos
        data['id'] = doc.id;
        return data;
      }).toList();

      return primeReminders;
    } catch (error) {
      print('Error al obtener los recordatorios prime: $error');
      throw error;
    }
  }

  static Future<bool> checkReminderExists(
      BuildContext context, int idRecordar, DateTime date) async {
    try {
      // Realizar la consulta para verificar si existe un recordatorio para este día y este ID
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(nick)
          .collection('Recordatorios');
      final querySnapshot = await userCollectionRef
          .where('idRecordar', isEqualTo: idRecordar)
          .where('day', isEqualTo: DateFormat('yyyy-MM-dd').format(date))
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error al verificar si existe el recordatorio: $error');
      return false;
    }
  }

static Future<List<Map<String, dynamic>>> getAllRemindersClon(BuildContext context) async {
  try {
    Globales globales = Provider.of<Globales>(context, listen: false);
    String nick = globales.nick;
    final userCollectionRef = FirebaseFirestore.instance
        .collection('Seguimiento')
        .doc(nick)
        .collection('Recordatorios');
    final querySnapshot = await userCollectionRef
        .where('modelo', isEqualTo: 'clon')
        .orderBy('startTime')
        .get();

    final reminders = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      // Convertir las cadenas de texto de startTime y endTime a objetos DateTime
      data['startTime'] = DateTime.parse(data['startTime']);
      data['endTime'] = DateTime.parse(data['endTime']);
      // Agregar el ID del documento al mapa de datos
      data['id'] = doc.id;
      return data;
    }).toList();

    return reminders;
  } catch (error) {
    print('Error al obtener todos los recordatorios de tipo clon: $error');
    throw error;
  }
}


  static Future<Map<String, dynamic>> getReminderById(
      BuildContext context, String reminderId) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;
      final reminderRef = FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(nick)
          .collection('Recordatorios')
          .doc(reminderId);
      final docSnapshot = await reminderRef.get();

      if (docSnapshot.exists) {
        return {'reminder': docSnapshot.data()};
      } else {
        return {'error': 'No se encontró el recordatorio'};
      }
    } catch (error) {
      print('Error al obtener recordatorio por ID: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<Map<String, dynamic>> getReminderByIdRecordar(
      BuildContext context, int reminderId) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;

      // Consultar el último recordatorio con el idRecordar dado
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(nick)
          .collection('Recordatorios')
          .where('idRecordar', isEqualTo: reminderId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      // Verificar si se encontraron resultados
      if (querySnapshot.docs.isNotEmpty) {
        // Convertir el documento a un mapa de datos y devolverlo
        return {'reminder': querySnapshot.docs.first.data()};
      } else {
        // Si no se encontraron documentos, devolver un error
        return {'error': 'No se encontró el recordatorio'};
      }
    } catch (error) {
      print('Error al obtener el recordatorio por ID: $error');
      return {'error': 'Error en la solicitud'};
    }
  }
 static Future<List<Map<String, dynamic>?>> getFilteredPrimeReminders(BuildContext context, String tipo, int selectedDay) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;
      final userCollectionRef = FirebaseFirestore.instance.collection('Seguimiento').doc(nick).collection('Recordatorios');
      
      final querySnapshot = await userCollectionRef
  .where('modelo', isEqualTo: 'Prime')
  .where('tipo', isEqualTo: tipo)
  .orderBy('startTime', descending: true) // Ordenar por startTime en orden descendente
  .get();

      final reminders = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        // Convertir las cadenas de texto de startTime y endTime a objetos DateTime
        data['startTime'] = DateTime.parse(data['startTime']);
        data['endTime'] = DateTime.parse(data['endTime']);

        // Verificar si el día seleccionado está en el arreglo repeatDays
        List<int> repeatDays = List<int>.from(data['repeatDays']);
        bool isValidDay = repeatDays.contains(selectedDay);
        
        // Si el día es válido, agregar el ID del documento al mapa de datos
        if (isValidDay) {
          data['id'] = doc.id;
          return data;
        } else {
          return null; // No se incluirá este recordatorio en la lista final
        }
      }).toList();

      // Eliminar los elementos nulos de la lista
      return reminders.where((element) => element != null).toList();
    } catch (error) {
      print('Error al obtener los recordatorios prime filtrados: $error');
      throw error;
    }
  }
  
  static Future<Map<String, dynamic>> updateReminderIdrecordar(BuildContext context,
      int reminderId, Map<String, dynamic> updatedReminder) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;

      // Consulta los documentos que coincidan con el campo idRecordar
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(nick)
          .collection('Recordatorios')
          .where('idRecordar', isEqualTo: reminderId)
          .get();

      // Actualiza cada documento encontrado con los nuevos datos
      for (final doc in querySnapshot.docs) {
        await doc.reference.update(updatedReminder);
      }

      return {'message': 'Recordatorios actualizados correctamente'};
    } catch (error) {
      print('Error al actualizar recordatorios: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<Map<String, dynamic>> deleteReminderIdRecordar(
      BuildContext context, int reminderId) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;

      // Consulta los documentos que coincidan con el campo idRecordar
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Seguimiento')
          .doc(nick)
          .collection('Recordatorios')
          .where('idRecordar', isEqualTo: reminderId)
          .get();

      // Elimina cada documento encontrado
      for (final doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      return {'message': 'Recordatorios eliminados correctamente'};
    } catch (error) {
      print('Error al eliminar recordatorios: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<Map<String, dynamic>> deleteReminderById(BuildContext context, String reminderId) async {
    try {
      Globales globales = Provider.of<Globales>(context, listen: false);
      String nick = globales.nick;

      // Referencia al documento del recordatorio
      final reminderRef = FirebaseFirestore.instance.collection('Seguimiento').doc(nick).collection('Recordatorios').doc(reminderId);

      // Eliminar el documento
      await reminderRef.delete();

      return {'message': 'Recordatorio eliminado correctamente'};
    } catch (error) {
      print('Error al eliminar el recordatorio: $error');
      return {'error': 'Error en la solicitud'};
    }
  }
}
