// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/reminder_model.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/widgets/date_time_selector.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/reminder_scheduler.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/color_menu_widget.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/days_menu_widget.dart';
import 'package:gym_check/src/services/reminder_service.dart';
import 'package:intl/intl.dart';

class AddPrimaryReminderPage extends StatefulWidget {
  final DateTime? selectedDate;
  final String tipo;
  final String? recordatorioId;

  const AddPrimaryReminderPage(
      {Key? key, this.selectedDate, required this.tipo, this.recordatorioId})
      : super(key: key);

  @override
  _AddPrimaryReminderPageState createState() => _AddPrimaryReminderPageState();
}

class _AddPrimaryReminderPageState extends State<AddPrimaryReminderPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;
  Color _selectedColor = Colors.red;
  int dropdownValue = 10;
  Map<String, dynamic>? _reminderData;
  bool repeatReminder = false;
  List<int> _selectedRepeatDays =
      []; // Lista de días seleccionados para repetir el recordatorio (1 para Lunes, 2 para Martes, etc.)
  String dayOfWeek = "";
  String formattedDate = "";
  String tipo = "";

  @override
  void initState() {
    super.initState();
    _selectedColor = Colors.red;
    dropdownValue = 10;
    dayOfWeek = _getDayOfWeek(widget.selectedDate ?? DateTime.now());
    formattedDate =
        DateFormat('dd-MM-yyyy').format(widget.selectedDate ?? DateTime.now());
    tipo = widget.tipo;

    if (widget.recordatorioId != null) {
      _loadReminderData();
      print(_reminderData!['idRecordar']);
    }
  }

  Widget build(BuildContext context) {
    String tipo = widget.tipo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: const Text(
          'Crear Recordatorio',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        iconTheme: const IconThemeData(
          color:
              Colors.white, // Cambia el color del icono de retroceso a blanco
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              // CreateWidgets.showInfo(context, "Crear rutina",
              //     "Una rutina lleva series y una serie lleva ejercicios");
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.selectedDate != null) ...[
                SizedBox(
                  height: 10,
                ),
                Text(
                  "$tipo para el día $dayOfWeek $formattedDate",
                  style: TextStyle(color: Colors.white),
                ),
              ],
              const SizedBox(height: 18.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      maxLength: 25,
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText:
                            'Nombre del recordatorio (max. 25 caracteres)',
                        counterStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un nombre para el recordatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15.0),
                    TextFormField(
                      maxLength: 120,
                      controller: _descripcionController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        labelText:
                            'Descripción del recordatorio (max. 120 caracteres)',
                        counterStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una descripción para el recordatorio';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DateTimeSelectorFormField(
                        decoration: const InputDecoration(
                          labelText: "Hora de Inicio",
                          labelStyle: TextStyle(color: Colors.white),
                          counterStyle: TextStyle(color: Colors.white),
                          border: InputBorder
                              .none, // Remueve el borde predeterminado
                        ),
                        textStyle: TextStyle(color: Colors.white),
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
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DateTimeSelectorFormField(
                        decoration: const InputDecoration(
                          labelText: "Hora de Finalización",

                          labelStyle: TextStyle(color: Colors.white),
                          counterStyle: TextStyle(color: Colors.white),
                          border: InputBorder
                              .none, // Remueve el borde predeterminado
                        ),
                        textStyle: TextStyle(color: Colors.white),
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
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  ColorDropdown(
                    colorselec: _selectedColor,
                    onColorSelected: (color) {
                      _selectedColor = color!;
                    },
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: repeatReminder,
                        onChanged: (value) {
                          setState(() {
                            repeatReminder = value!;
                          });
                        },
                      ),
                      const Text("Repetir recordatorio",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
              if (repeatReminder) ...[
                SizedBox(height: 15),
                DaysDropdown(
                  onDaysNumberSelected: (daysNumber) {
                    setState(() {
                      dropdownValue = daysNumber!;
                    });
                  },
                  onDaysSelected: (days) {
                    setState(() {
                      _selectedRepeatDays = days!;
                    });
                  },
                ),
              ],
              const SizedBox(height: 20.0),
              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addReminder();
                  }
                },
                text: 'Agregar',
                icon: Icons.add_alarm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addReminder() async {
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favoringrese la hora de inicio y fin')),
      );
      return;
    }

    if (_startTime!.isAfter(_endTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'La hora de finalización debe ser después de la hora de inicio')),
      );
      return;
    }

    // Mostrar AlertDialog mientras se crea la rutina
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          backgroundColor: Colors.black, // Fondo negro
          title: Text(
            'Creando...',
            style: TextStyle(color: Colors.white), // Letras blancas
          ),
          content: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white), // Color del indicador de progreso blanco
          ),
        );
      },
    );

    String tipoModelo = "";
    if (repeatReminder == true) {
      tipoModelo = "Prime";
    } else {
      tipoModelo = "clon";
    }

    // Obtener la fecha actual o la fecha seleccionada
    DateTime currentDate = widget.selectedDate ?? DateTime.now();
    DateTime nextSelectedDay = currentDate;
    //List<int> si = _selectedRepeatDays;

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

    Reminder reminder;

    if (widget.tipo == "Recordatorio") {
      // Crear un recordatorio simple
      reminder = Reminder(
          //day: DateFormat('EEEE').format(widget.selectedDate),
          modelo: tipoModelo,
          tipo: widget.tipo,
          terminado: false,
          //title: _title,
          idRecordar: generateRandomNumber(),
          title: _nombreController.text,
          description: _descripcionController.text,
          startTime: combinedStartTime,
          endTime: combinedEndTime,
          color: _selectedColor,
          repeatDays: _selectedRepeatDays);

      final response =
          await ReminderService.createReminder(context, reminder.toJson());

      // if (repeatReminder == true) {
      ReminderScheduler.scheduleReminders(context, reminder, dropdownValue,
          widget.selectedDate ?? DateTime.now());
      // }

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
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black, // Fondo negro
          title: const Text(
            'Recordatorio creado',
            style: TextStyle(color: Colors.white), // Letras blancas
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'El recordatorio ha sido almacenado correctamente, y puede encontrarlos en tu calendario.',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Reinicia la página
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const PrincipalPage(
                        initialPageIndex: 2,
                      ),
                    ),
                  );
                },
                child: const Text('Aceptar',
                    style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );
  }

  int generateRandomNumber() {
    Random random = Random();
    int randomNumber =
        random.nextInt(999999); // Genera un número aleatorio entre 0 y 999999
    return randomNumber;
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
}
