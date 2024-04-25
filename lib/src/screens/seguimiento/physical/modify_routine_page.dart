import 'package:flutter/material.dart';
import 'package:gym_check/src/services/reminder_service.dart';

class ModifyRoutinePage extends StatefulWidget {
  final String routineId;

  const ModifyRoutinePage({Key? key, required this.routineId}) : super(key: key);

  @override
  _ModifyRoutinePageState createState() => _ModifyRoutinePageState();
}

class _ModifyRoutinePageState extends State<ModifyRoutinePage> {
  TimeOfDay _startTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 0, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modificar Rutina'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selecciona la nueva hora de inicio:'),
            ElevatedButton(
              onPressed: () async {
                final newStartTime = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                );
                if (newStartTime != null) {
                  setState(() {
                    _startTime = newStartTime;
                  });
                }
              },
              child: Text('${_startTime.format(context)}'),
            ),
            Text('Selecciona la nueva hora de fin:'),
            ElevatedButton(
              onPressed: () async {
                final newEndTime = await showTimePicker(
                  context: context,
                  initialTime: _endTime,
                );
                if (newEndTime != null) {
                  setState(() {
                    _endTime = newEndTime;
                  });
                }
              },
              child: Text('${_endTime.format(context)}'),
            ),
            ElevatedButton(
              onPressed: () async {
                final response = await ReminderService.updateReminder(
                  context,
                  widget.routineId,
                  {
                    'startTime': _startTime.toString(),
                    'endTime': _endTime.toString(),
                  },
                );
                if (response.containsKey('message')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response['message']!)),
                  );
                } else if (response.containsKey('error')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(response['error']!)),
                  );
                }
              },
              child: const Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
