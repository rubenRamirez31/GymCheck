import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_check/src/providers/user_session_provider.dart';
import 'package:gym_check/src/services/user_service.dart';
import 'package:provider/provider.dart';

class ReminderService {
  static Future<Map<String, dynamic>> createReminder(BuildContext context, Map<String, dynamic> reminder) async {
    try {
      String nick = await _getNick(context);
      final userCollectionRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick).collection('Recordatorios');
      await userCollectionRef.add(reminder);
      return {'message': 'Recordatorio creado exitosamente'};
    } catch (error) {
      print('Error al crear recordatorio: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<List<Map<String, dynamic>>> getAllReminders(BuildContext context) async {
    try {
      String nick = await _getNick(context);
      final userCollectionRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick).collection('Recordatorios');
      final querySnapshot = await userCollectionRef.orderBy('startTime').get();
      
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
      print('Error al obtener todos los recordatorios: $error');
      throw error;
    }
  }

 static Future<List<Map<String, dynamic>>> getRemindersByDay(
      BuildContext context, String day, String tipo) async {
    try {
      String nick = await _getNick(context);
      final userCollectionRef = FirebaseFirestore.instance
          .collection('Datos-Fisicos')
          .doc(nick)
          .collection('Recordatorios');
      final querySnapshot = await userCollectionRef
          .where('day', isEqualTo: day)
          .where('tipo', isEqualTo: tipo) // Filtrar por tipo
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
      print('Error al obtener recordatorios por día: $error');
      throw error;
    }
      }

  static Future<Map<String, dynamic>> getReminderById(BuildContext context, String reminderId) async {
    try {
      String nick = await _getNick(context);
      final reminderRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick).collection('Recordatorios').doc(reminderId);
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

  static Future<Map<String, dynamic>> updateReminder(BuildContext context, String reminderId, Map<String, dynamic> updatedReminder) async {
    try {
      String nick = await _getNick(context);
      final reminderRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick).collection('Recordatorios').doc(reminderId);
      await reminderRef.update(updatedReminder);
      return {'message': 'Recordatorio actualizado correctamente'};
    } catch (error) {
      print('Error al actualizar recordatorio: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<Map<String, dynamic>> deleteReminder(BuildContext context, String reminderId) async {
    try {
      String nick = await _getNick(context);
      final reminderRef = FirebaseFirestore.instance.collection('Datos-Fisicos').doc(nick).collection('Recordatorios').doc(reminderId);
      await reminderRef.delete();
      return {'message': 'Recordatorio eliminado correctamente'};
    } catch (error) {
      print('Error al eliminar recordatorio: $error');
      return {'error': 'Error en la solicitud'};
    }
  }

  static Future<String> _getNick(BuildContext context) async {
    String userId = Provider.of<UserSessionProvider>(context, listen: false).userSession!.userId;
    Map<String, dynamic> userData = await UserService.getUserData(userId);
    return userData['nick'];
  }
}
