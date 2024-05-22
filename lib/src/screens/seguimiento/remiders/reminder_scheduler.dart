import 'package:flutter/material.dart';
import 'package:gym_check/src/models/reminder_model.dart';
import 'package:gym_check/src/services/reminder_service.dart';

class ReminderScheduler {
  static Future<void> scheduleReminders(
      BuildContext context, Reminder primeReminder, int dias) async {
    try {
      DateTime startTime = primeReminder.startTime;
      DateTime endTime = primeReminder.endTime;
      List<int>? repeatDays = primeReminder.repeatDays;

//if (repeatDays != null && repeatDays.isNotEmpty) {
        await _createClonedReminders(context, primeReminder, dias);
   //   }
    } catch (error) {
      print('Error al programar recordatorios: $error');
    }
  }

  static Future<void> _createClonedReminders(
      BuildContext context, Reminder primeReminder, int dias) async {
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < dias; i++) {
      DateTime nextDay = currentDate.add(Duration(days: i));

      if (primeReminder.repeatDays.contains(nextDay.weekday)) {
        bool reminderExists = await ReminderService.checkReminderExists(
            context, primeReminder.idRecordar, nextDay);

        if (!reminderExists) {
          Reminder clonedReminder = primeReminder.clone();
          clonedReminder.modelo = 'clon';
          clonedReminder.startTime =
              _adjustDate(primeReminder.startTime, nextDay);
          clonedReminder.endTime = _adjustDate(primeReminder.endTime, nextDay);

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
  final Reminder primeReminder;

  const ReminderButton(
      {Key? key, required this.onPressed, required this.primeReminder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Programar Recordatorios'),
    );
  }
}
