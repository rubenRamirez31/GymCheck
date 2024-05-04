import 'package:flutter/material.dart';
import 'package:gym_check/src/models/reminder_model.dart';
import 'package:gym_check/src/services/reminder_service.dart';

class ReminderScheduler {
  static Future<void> scheduleReminders(BuildContext context) async {
    try {
// 1. Obtener todos los recordatorios "prime"
List<Map<String, dynamic>> primeReminders =
    await ReminderService.getPrimeReminders(context);

for (var reminderMap in primeReminders) {
  DateTime startTime = DateTime.parse(reminderMap['startTime']);
  DateTime endTime = DateTime.parse(reminderMap['endTime']);
  List<int>? repeatDays = reminderMap['repeatDays']?.cast<int>(); // Convertir a lista de enteros

  if (repeatDays != null && repeatDays.isNotEmpty) {
    Reminder primeReminder = Reminder(
      idRecordar: reminderMap['idRecordar'],
      day: reminderMap['day'],
      terminado: reminderMap['terminado'],
      modelo: reminderMap['modelo'],
      tipo: reminderMap['tipo'],
      title: reminderMap['title'],
      description: reminderMap['description'],
      routineName: reminderMap['routineName'],
      primaryFocus: reminderMap['primaryFocus'],
      secondaryFocus: reminderMap['secondaryFocus'],
      startTime: startTime,
      endTime: endTime,
      color: Color(reminderMap['color']),


      workoutID: reminderMap['workoutID'],
      dietID: reminderMap['dietID'],
      repeatDays: repeatDays,
    );

    await _createClonedReminders(context, primeReminder);
  }
}

    } catch (error) {
      print('Error al programar recordatorios: $error');
    }
  }

static Future<void> _createClonedReminders(
    BuildContext context, Reminder primeReminder) async {
  // Obtener la fecha actual
  DateTime currentDate = DateTime.now();

  // Crear los recordatorios "clon" para los próximos 10 días
  for (int i = 0; i < 30; i++) {
    DateTime nextDay = currentDate.add(Duration(days: i));

    // Verificar si el día actual está en los días de repetición
    if (primeReminder.repeatDays.contains(nextDay.weekday)) {
      // Verificar si ya existe un recordatorio para este día y este ID
      bool reminderExists = await ReminderService.checkReminderExists(
          context, primeReminder.idRecordar, nextDay);

      if (!reminderExists) {
        // Clonar el recordatorio y ajustar la fecha
        Reminder clonedReminder = primeReminder.clone();
        clonedReminder.modelo = 'clon'; // Establecer el modelo como "clon"
        clonedReminder.startTime =
            _adjustDate(primeReminder.startTime, nextDay);
        clonedReminder.endTime = _adjustDate(primeReminder.endTime, nextDay);

        // Crear el recordatorio "clon"
        await ReminderService.createReminderClonado(
            context, clonedReminder.toJson());
      }
    }
  }

  
}






  static DateTime _adjustDate(DateTime dateTime, DateTime newDate) {
    return DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      dateTime.hour,
      dateTime.minute,
    );
  }
}

class ReminderButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ReminderButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Programar Recordatorios'),
    );
  }
}
