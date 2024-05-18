// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/reminder_model.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/screens/calendar/widgets/date_time_selector.dart';
import 'package:gym_check/src/screens/crear/home_create_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/all_workout_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/view_workout_page.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/reminder_scheduler.dart';
import 'package:gym_check/src/services/reminder_service.dart';
import 'package:gym_check/src/services/workout_service.dart';
import 'package:intl/intl.dart';

class AddReminderPage extends StatefulWidget {
  final DateTime? selectedDate;
  final String tipo;
  final String? rutinaId;
  final String? idRecordar;
  final String? recordatorioId;

  const AddReminderPage(
      {Key? key,
      this.selectedDate,
      required this.tipo,
      this.rutinaId,
      this.idRecordar,
      this.recordatorioId})
      : super(key: key);

  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  
  List<Map<String, dynamic>> _rutina = [];

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

  Map<String, dynamic>? _reminderData;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate ?? DateTime.now();
    if (widget.recordatorioId != null) {
      _loadReminderData();
    }
  }

  Future<void> _loadReminderData() async {
    final reminderData = await ReminderService.getReminderById(
        context, widget.recordatorioId ?? "");
    setState(() {
      _reminderData = reminderData['reminder'];
      //_isLoading = false;
    });
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
              if (widget.tipo == "Rutina") ...[
                _rutina.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 18, 18, 18),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 0.5),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 100, // Altura máxima de 300 píxeles
                          ),
                          child: ReorderableListView(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            children: _rutina
                                .where((item) => item.containsKey('rutina'))
                                .map((item) {
                              String idRutina = item['rutina']['id'];
                              String nombre = item['rutina']['nombre'];
                              return GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    backgroundColor:
                                        const Color.fromARGB(255, 18, 18, 18),
                                    scrollControlDisabledMaxHeightRatio: 0.9,
                                    enableDrag: false,
                                    showDragHandle: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15),
                                      ),
                                    ),
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return FractionallySizedBox(
                                        heightFactor: 0.96,
                                        child: ViewWorkoutPage(
                                          id: idRutina,
                                        ),
                                      );
                                    },
                                  );
                                },
                                key: ValueKey(idRutina),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 83, 83, 83),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Nombre: $nombre',
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _eliminar(item);
                                        },
                                        icon: const Icon(Icons.delete),
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
                                final item = _rutina.removeAt(oldIndex);
                                _rutina.insert(newIndex, item);
                              });
                            },
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _mostrarSeleccionarRutina();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          height: 100,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 18, 18, 18),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 0.5),
                          ),
                          child: const Center(
                            child: Text(
                              'Agregar una rutina',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],

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

  Future<void> _loadRutinaSelect() async {
    print(widget.rutinaId);
    try {
      if (widget.rutinaId != null) {
        final serie =
            await RutinaService.obtenerRutinaPorId(context, widget.rutinaId!);
        setState(() {
          if (serie != null) {
            _agregarSerie(serie);
            print(serie);
          }
          //_exercise = exercise;
        });
      }
    } catch (error) {
      print('Error loading exercise: $error');
    }
  }

  void _mostrarSeleccionarRutina() async {
    final rutina = await showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      enableDrag: false,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      builder: (context) {
        // Aquí puedes implementar la lógica para mostrar una lista de series disponibles
        return const FractionallySizedBox(
          heightFactor: 0.96,
          child: AllWorkoutPage(
            agregar: true,
          ),
        );
      },
    );

    if (rutina != null) {
      _agregarSerie(rutina);
    }
  }

  void _agregarSerie(Workout rutina) {
    _rutina.add({
      'rutina': {'id': rutina.id, 'nombre': rutina.name}
    });
    setState(() {});
  }

  void _eliminar(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar'),
        content:
            const Text('¿Estás seguro de que quieres eliminar este elemento?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _rutina.remove(item);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
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
      final rutina = await RutinaService.obtenerRutinaPorId(
          context, _rutina.first['rutina']['id']);

      Reminder reminder = Reminder(
          //day: _getDayOfWeek(_currentDate),
          modelo: "Prime",
          workoutID: _rutina.first['rutina']['id'],
          idRecordar: generateRandomNumber(),
          terminado: false,
          tipo: widget.tipo,
          title: _title,
          description: _description,
          color: _selectedColor,
          routineName: rutina?.name,
          primaryFocus: rutina?.primaryFocus,
          secondaryFocus: rutina?.secondaryFocus,
          startTime: combinedStartTime, // Usar la fecha y hora combinadas
          endTime: combinedEndTime, // Usar la fecha y hora combinadas
          repeatDays: _selectedRepeatDays);
      print(si);
      final response =
          await ReminderService.createReminder(context, reminder.toJson());
      // ignore: use_build_context_synchronously
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

        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const PrincipalPage(
              initialPageIndex: 2,
            ),
          ),
        );
      }
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
