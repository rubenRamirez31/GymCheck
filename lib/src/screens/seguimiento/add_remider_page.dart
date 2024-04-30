import 'package:flutter/material.dart';
import 'package:gym_check/src/models/reminder_model.dart';
import 'package:gym_check/src/screens/calendar/widgets/date_time_selector.dart';
import 'package:gym_check/src/services/reminder_service.dart';
import 'package:intl/intl.dart';

// Lista de rutinas estáticas
final List<Map<String, String>> staticRoutines = [
  {'name': 'Rutina 1', 'primaryFocus': 'Focus 1', 'secondaryFocus': 'Focus 2'},
  {'name': 'Rutina 2', 'primaryFocus': 'Focus 3', 'secondaryFocus': 'Focus 4'},
  {'name': 'Rutina 3', 'primaryFocus': 'Focus 5', 'secondaryFocus': 'Focus 6'},
  {'name': 'Rutina 4', 'primaryFocus': 'Focus 7', 'secondaryFocus': 'Focus 8'},
  {'name': 'Rutina 5', 'primaryFocus': 'Focus 9', 'secondaryFocus': 'Focus 10'},
];

class AddReminderPage extends StatefulWidget {
  final DateTime selectedDate;
  final String tipo;

  const AddReminderPage(
      {Key? key, required this.selectedDate, required this.tipo})
      : super(key: key);

  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  Map<String, String> _selectedRoutine =
      staticRoutines[0]; // Rutina seleccionada en el menú desplegable

  String _title = "";
  String _description = "";
  DateTime? _startTime;
  DateTime? _endTime;
  Color _selectedColor = Colors.blue;
  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
  ];

  String _getDayOfWeek(DateTime date) {
    // Función para obtener el nombre del día de la semana a partir de un DateTime
    switch (date.weekday) {
      case DateTime.monday:
        return 'Lunes';
      case DateTime.tuesday:
        return 'Martes';
      case DateTime.wednesday:
        return 'Miércoles';
      case DateTime.thursday:
        return 'Jueves';
      case DateTime.friday:
        return 'Viernes';
      case DateTime.saturday:
        return 'Sábado';
      case DateTime.sunday:
        return 'Domingo';
      default:
        return '';
    }
  }

  Widget build(BuildContext context) {
    String dayOfWeek = _getDayOfWeek(widget.selectedDate);
    String formattedDate = DateFormat('dd-MM-yyyy').format(widget.selectedDate);
    String tipo = widget.tipo;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.tipo == "Rutina") ...[
              DropdownButton<Map<String, String>>(
                value: _selectedRoutine,
                onChanged: (Map<String, String>? newValue) {
                  setState(() {
                    _selectedRoutine = newValue!;
                  });
                },
                items: staticRoutines.map((Map<String, String> value) {
                  return DropdownMenuItem<Map<String, String>>(
                    value: value,
                    child: Text(value['name']!),
                  );
                }).toList(),
              ),
              SizedBox(height: 20.0),
            ],
            Text("$tipo para el día $dayOfWeek $formattedDate"),
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Título",
                hintText: "Ingrese un título",
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
              },
              decoration: InputDecoration(
                labelText: "Descripción",
                hintText: "Ingrese una descripción",
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: DateTimeSelectorFormField(
                    decoration: InputDecoration(
                      labelText: "Hora de Inicio",
                    ),
                    initialDateTime: _startTime,
                    minimumDateTime: DateTime(2000),
                    onSelect: (date) {
                      setState(() {
                        _startTime = date;
                      });
                    },
                    type: DateTimeSelectionType.time,
                  ),
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: DateTimeSelectorFormField(
                    decoration: InputDecoration(
                      labelText: "Hora de Finalización",
                    ),
                    initialDateTime: _endTime,
                    minimumDateTime: DateTime(2000),
                    onSelect: (date) {
                      setState(() {
                        _endTime = date;
                      });
                    },
                    type: DateTimeSelectionType.time,
                  ),
                ),
              ],
            ),
            DropdownButton<Color>(
              value: _selectedColor,
              onChanged: (Color? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedColor = newValue;
                  });
                }
              },
              items: _colors.map<DropdownMenuItem<Color>>((Color color) {
                return DropdownMenuItem<Color>(
                  value: color,
                  child: Container(
                    width: 30,
                    height: 30,
                    color: color,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _addReminder();
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addReminder() async {
    Reminder reminder;
    // Extraer día, mes y año de selectedDate
    int year = widget.selectedDate.year;
    int month = widget.selectedDate.month;
    int day = widget.selectedDate.day;

// Combinar fecha y hora de inicio
    DateTime combinedStartTime =
        DateTime(year, month, day, _startTime!.hour, _startTime!.minute);

// Combinar fecha y hora de fin
    DateTime combinedEndTime =
        DateTime(year, month, day, _endTime!.hour, _endTime!.minute);

    if (_title.isEmpty || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    if (_selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleccione un color')),
      );
      return;
    }

    if (_startTime!.isAfter(_endTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'La hora de finalización debe ser después de la hora de inicio')),
      );
      return;
    }

    if (widget.tipo == "Rutina") {
      //tambien hay que guardar el id de la rutina

      String selectedRoutineName = _selectedRoutine['name']!;
      String primaryFocus = _selectedRoutine['primaryFocus']!;
      String secondaryFocus = _selectedRoutine['secondaryFocus']!;

      Reminder reminder = Reminder(
        day: _getDayOfWeek(widget.selectedDate),
        terminado: false,
        tipo: widget.tipo,
        title: _title,
        description: _description,
        color: _selectedColor,
        routineName: selectedRoutineName,
        primaryFocus: primaryFocus,
        secondaryFocus: secondaryFocus,
        startTime: combinedStartTime, // Usar la fecha y hora combinadas
        endTime: combinedEndTime, // Usar la fecha y hora combinadas

        
      );
       final response =
          await ReminderService.createReminder(context, reminder.toJson());

      if (response.containsKey('message')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message']!)),
        );
      } else if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error']!)),
        );
      }
      
      // Mostrar menú para seleccionar rutina
      // Aquí debería implementarse la lógica para seleccionar una rutina
      // Luego crear el Reminder con los datos de la rutina seleccionada
    } else if (widget.tipo == "Comida") {
      // Mostrar menú para seleccionar comida
      // Aquí debería implementarse la lógica para seleccionar una comida
      // Luego crear el Reminder con los datos de la comida seleccionada
    } else if (widget.tipo == "Recordatorio") {
      // Crear un recordatorio simple
      reminder = Reminder(
        //day: DateFormat('EEEE').format(widget.selectedDate),
        tipo: widget.tipo,
        terminado: false,
        title: _title,
        description: _description,
        startTime: combinedStartTime,
        endTime: combinedEndTime,

        color: _selectedColor,
      );

      final response =
          await ReminderService.createReminder(context, reminder.toJson());

      if (response.containsKey('message')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message']!)),
        );
      } else if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error']!)),
        );
      }
    }
  }
}
