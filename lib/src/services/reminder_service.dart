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
static Future<List<Map<String, dynamic>?>> getFilteredPrimeReminders(
  BuildContext context,
  String tipoPrincipal,
  int selectedDay, {
  String? tipoAdicional1,
  String? tipoAdicional2,
}) async {
  try {
    Globales globales = Provider.of<Globales>(context, listen: false);
    String nick = globales.nick;
    final userCollectionRef = FirebaseFirestore.instance
        .collection('Seguimiento')
        .doc(nick)
        .collection('Recordatorios');

    // Realiza la consulta principal por el tipo principal
    final queryPrincipal = userCollectionRef
        .where('modelo', isEqualTo: 'Prime')
        .where('tipo', isEqualTo: tipoPrincipal)
        .orderBy('startTime', descending: true);

    // Ejecuta la consulta y obtiene los resultados
    final querySnapshotPrincipal = await queryPrincipal.get();

    List<QueryDocumentSnapshot<Map<String, dynamic>>> combinedDocs = querySnapshotPrincipal.docs;

    // Si tipoAdicional1 no es nulo, realiza una segunda consulta
    if (tipoAdicional1 != null && tipoAdicional1.isNotEmpty) {
      final queryAdicional1 = userCollectionRef
          .where('modelo', isEqualTo: 'Prime')
          .where('tipo', isEqualTo: tipoAdicional1)
          .orderBy('startTime', descending: true);
      final querySnapshotAdicional1 = await queryAdicional1.get();
      combinedDocs.addAll(querySnapshotAdicional1.docs);
    }

    // Si tipoAdicional2 no es nulo, realiza una tercera consulta
    if (tipoAdicional2 != null && tipoAdicional2.isNotEmpty) {
      final queryAdicional2 = userCollectionRef
          .where('modelo', isEqualTo: 'Prime')
          .where('tipo', isEqualTo: tipoAdicional2)
          .orderBy('startTime', descending: true);
      final querySnapshotAdicional2 = await queryAdicional2.get();
      combinedDocs.addAll(querySnapshotAdicional2.docs);
    }

    final reminders = combinedDocs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['startTime'] = DateTime.parse(data['startTime']);
      data['endTime'] = DateTime.parse(data['endTime']);

      List<int> repeatDays = List<int>.from(data['repeatDays']);
      bool isValidDay = repeatDays.contains(selectedDay);

      if (isValidDay) {
        data['id'] = doc.id;
        return data;
      } else {
        return null;
      }
    }).toList();

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
        // Obtener los datos actuales del documento
        final currentData = doc.data();

        // Obtener las nuevas horas de updatedReminder
        final String? newStartTimeStr = updatedReminder['startTime'];
        final String? newEndTimeStr = updatedReminder['endTime'];

        DateTime? newStartTime;
        DateTime? newEndTime;

        // Parsear las nuevas horas solo si no son nulas y válidas
        if (newStartTimeStr != null && newStartTimeStr.isNotEmpty) {
          newStartTime = DateTime.parse(newStartTimeStr);
        }
        if (newEndTimeStr != null && newEndTimeStr.isNotEmpty) {
          newEndTime = DateTime.parse(newEndTimeStr);
        }

        // Obtener los DateTime actuales del documento y parsearlos desde String
        final DateTime currentStartTime = DateTime.parse(currentData['startTime']);
        final DateTime currentEndTime = DateTime.parse(currentData['endTime']);

        // Combinar las fechas actuales con las nuevas horas
        final DateTime updatedStartTime = newStartTime != null ? DateTime(
          currentStartTime.year,
          currentStartTime.month,
          currentStartTime.day,
          newStartTime.hour,
          newStartTime.minute,
        ) : currentStartTime;

        final DateTime updatedEndTime = newEndTime != null ? DateTime(
          currentEndTime.year,
          currentEndTime.month,
          currentEndTime.day,
          newEndTime.hour,
          newEndTime.minute,
        ) : currentEndTime;

        // Crear el mapa de datos combinados
        final Map<String, dynamic> mergedData = {...currentData};

        if (newStartTime != null) {
          mergedData['startTime'] = updatedStartTime.toIso8601String();
        }

        if (newEndTime != null) {
          mergedData['endTime'] = updatedEndTime.toIso8601String();
        }

        // Asegurar que los campos 'repeatDays' y 'modelo' no sean nulos si están presentes en el documento
        if (currentData.containsKey('repeatDays') && currentData['repeatDays'] != null) {
          mergedData['repeatDays'] = currentData['repeatDays'];
        }
        
        if (currentData.containsKey('modelo') && currentData['modelo'] != null) {
          mergedData['modelo'] = currentData['modelo'];
        }

        // Agregar otros datos que lleguen en updatedReminder, sin sobrescribir con nulos
        updatedReminder.forEach((key, value) {
          if (value != null) {
            mergedData[key] = value;
          }
        });

        // Actualizar el documento con los datos combinados
        await doc.reference.update(mergedData);
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
