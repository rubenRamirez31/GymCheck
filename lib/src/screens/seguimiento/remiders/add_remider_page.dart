import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/reminder_model.dart';
import 'package:gym_check/src/screens/calendar/widgets/date_time_selector.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/reminder_scheduler.dart';
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
  final DateTime? selectedDate;
  final String tipo;

  const AddReminderPage({Key? key, this.selectedDate, required this.tipo})
      : super(key: key);

  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  Map<String, String> _selectedRoutine =
      staticRoutines[0]; // Rutina seleccionada en el menú desplegable

  String _title = "";
  String _description = "";
  DateTime _currentDate = DateTime.now();

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

  int dropdownValue = 10;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate ?? DateTime.now();
  }

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

  List<int> _selectedRepeatDays =
      []; // Lista de días seleccionados para repetir el recordatorio (1 para Lunes, 2 para Martes, etc.)
  final List<Map<int, String>> _daysOptions = [
    {1: 'L'},
    {2: 'M'},
    {3: 'M'},
    {4: 'J'},
    {5: 'V'},
    {6: 'S'},
    {7: 'D'},
  ];

  Widget build(BuildContext context) {
    String dayOfWeek = _getDayOfWeek(widget.selectedDate ?? DateTime.now());
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(widget.selectedDate ?? DateTime.now());

    String tipo = widget.tipo;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
              if (widget.selectedDate != null) ...[
                Text("$tipo para el día $dayOfWeek $formattedDate"),
              ],
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

              Text("Seleciona cuantos dias"),

              DropdownButton<int>(
                value: dropdownValue,
                onChanged: (value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: <int>[10, 15, 30, 60].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),

              // if (widget.selectedDate == null) ...[
              SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Set scroll direction to horizontal
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Use Row for horizontal layout
                  children: _daysOptions.map((day) {
                    int dayIndex = day.keys.first;
                    String dayName = day.values.first;

                    return Row(
                      // Wrap each checkbox and text in a Row for horizontal alignment
                      children: [
                        Column(
                          children: [
                            Checkbox(
                              value: _selectedRepeatDays.contains(dayIndex),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value != null && value) {
                                    _selectedRepeatDays.add(dayIndex);
                                  } else {
                                    _selectedRepeatDays.remove(dayIndex);
                                  }
                                });
                              },
                            ),
                            //const SizedBox(width: 2.0), // Add spacing between checkbox and text
                            Text(dayName),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              // ],

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
      ),
    );
  }

  Future<void> _addReminder() async {
    // Obtener la fecha actual o la fecha seleccionada
    DateTime currentDate = widget.selectedDate ?? DateTime.now();
    DateTime nextSelectedDay = currentDate;
    List<int> si = _selectedRepeatDays;

    // Si _selectedRepeatDays está vacío y widget.selectedDate es nulo, se asigna la fecha actual
    if (_selectedRepeatDays.isEmpty && widget.selectedDate == null) {
      currentDate = DateTime.now();
    }

    // Si widget.selectedDate es diferente de null, establece nextSelectedDay en la fecha seleccionada
    if (widget.selectedDate != null) {
      nextSelectedDay = widget.selectedDate!;
    } else {
      // Si hay días seleccionados, encuentra el próximo día seleccionado basado en los días elegidos
      if (_selectedRepeatDays.isNotEmpty) {
        int currentWeekday = nextSelectedDay.weekday;
        int selectedDayIndex = _selectedRepeatDays.firstWhere(
          (dayIndex) => dayIndex >= currentWeekday,
          orElse: () => _selectedRepeatDays.first,
        );

        if (selectedDayIndex != currentWeekday) {
          nextSelectedDay = nextSelectedDay
              .add(Duration(days: (selectedDayIndex - currentWeekday)));
        }
      }
    }

    // Combinar fecha y hora de inicio
    DateTime combinedStartTime = DateTime(
      nextSelectedDay.year,
      nextSelectedDay.month,
      nextSelectedDay.day,
      _startTime!.hour,
      _startTime!.minute,
    );

    // Combinar fecha y hora de fin
    DateTime combinedEndTime = DateTime(
      nextSelectedDay.year,
      nextSelectedDay.month,
      nextSelectedDay.day,
      _endTime!.hour,
      _endTime!.minute,
    );

    print(si);
    Reminder reminder;

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
          //day: _getDayOfWeek(_currentDate),
          modelo: "Prime",
          idRecordar: generateRandomNumber(),
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
          repeatDays: _selectedRepeatDays);
      print(si);
      final response =
          await ReminderService.createReminder(context, reminder.toJson());
          ReminderScheduler.scheduleReminders(context, reminder, dropdownValue);

      if (response.containsKey('message')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message']!)),
        );
      } else if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error']!)),
        );
      } else {
        // Si se creó el recordatorio "Prime" correctamente, programar la replicación
        Reminder clonedReminder = reminder.clone();
        clonedReminder.modelo = 'clon';

        // Llamar a la función para programar los recordatorios
       // 
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
          modelo: "Prime",
          tipo: widget.tipo,
          terminado: false,
          title: _title,
          idRecordar: generateRandomNumber(),
          description: _description,
          startTime: combinedStartTime,
          endTime: combinedEndTime,
          color: _selectedColor,
          repeatDays: _selectedRepeatDays);

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

  int generateRandomNumber() {
    Random random = Random();
    int randomNumber =
        random.nextInt(999999); // Genera un número aleatorio entre 0 y 999999
    return randomNumber;
  }
}
