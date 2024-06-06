// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gym_check/src/models/alimento.dart';
import 'package:gym_check/src/models/reminder_model.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/widgets/date_time_selector.dart';
import 'package:gym_check/src/screens/crear/alimentacion/all_alimento_page.dart';
import 'package:gym_check/src/screens/crear/alimentacion/view_food_page.dart';
import 'package:gym_check/src/screens/crear/home_create_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/all_workout_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/view_workout_page.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/reminder_scheduler.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/color_menu_widget.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/days_menu_widget.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/tracking_widgets.dart';
import 'package:gym_check/src/services/food_service.dart';

import 'package:gym_check/src/services/reminder_service.dart';
import 'package:gym_check/src/services/workout_service.dart';
import 'package:intl/intl.dart';

class AddReminderPage extends StatefulWidget {
  final DateTime? selectedDate;
  final String tipo;
  final String? rutinaId;
  final String? alimentoId;
  final String? idRecordar;
  final String? recordatorioId;

  const AddReminderPage(
      {Key? key,
      this.selectedDate,
      required this.tipo,
      this.rutinaId,
      this.alimentoId,
      this.idRecordar,
      this.recordatorioId})
      : super(key: key);

  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  List<Map<String, dynamic>> _rutina = [];
  List<Map<String, dynamic>> _alimento = [];

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

  int dropdownValue = 0;

  Map<String, dynamic>? _reminderData;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.selectedDate ?? DateTime.now();
    if (widget.recordatorioId != null) {
      // _loadReminderData();
    }

    _loadRutinaSelect();
    _loadAlimentoSelect();
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

  //int dropdownValue = 10; // Valor inicial del dropdown
  bool repeatReminder = false; // Estado inicial del checkbox
  List<Map<int, String>> _daysOptions = [
    {1: 'Lun'},
    {2: 'Mar'},
    {3: 'Mié'},
    {4: 'Jue'},
    {5: 'Vie'},
    {6: 'Sáb'},
    {7: 'Dom'},
  ]; //

  List<int> _selectedRepeatDays =
      []; // Lista de días seleccionados para repetir el recordatorio (1 para Lunes, 2 para Martes, etc.)

  Widget build(BuildContext context) {
    String dayOfWeek = _getDayOfWeek(widget.selectedDate ?? DateTime.now());
    String formattedDate =
        DateFormat('dd-MM-yyyy').format(widget.selectedDate ?? DateTime.now());

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
          padding: const EdgeInsets.all(20.0),
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
              const SizedBox(height: 20.0),
              TextFormField(
                maxLength: 25,
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del recordatorio (max. 25 caracteres)',
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
              if (widget.tipo == "Rutina") ...[_builRutinas()],
              if (widget.tipo == "Alimento") ...[_builAlimetos()],
              const SizedBox(height: 15.0),
              ColorDropdown(
                onColorSelected: (color) {
                  _selectedColor = color!;
                },
              ),
              const SizedBox(height: 20.0),
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
                  if (widget.tipo == "Rutina") {
                    if (_rutina.isEmpty) {
                      TrackingWidgets.showInfo(
                        context,
                        'Error al crear recordatorio',
                        'Debes de agregar una rutina antes de crear el recordatorio ;).',
                      );
                    } else {
                      _addReminder();
                    }
                  } else {
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

  Widget _builRutinas() {
    return _rutina.isNotEmpty
        ? Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 18, 18, 18),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 0.5),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 75, // Altura máxima de 300 píxeles
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
                        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
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
                              buttons: false,
                            ),
                          );
                        },
                      );
                    },
                    key: ValueKey(idRutina),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 83, 83, 83),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rutina: $nombre',
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
              height: 75,
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
          );
  }

  Widget _builAlimetos() {
    return _alimento.isNotEmpty
        ? Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 18, 18, 18),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 0.5),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 75, // Altura máxima de 300 píxeles
              ),
              child: ReorderableListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: _alimento
                    .where((item) => item.containsKey('alimento'))
                    .map((item) {
                  String idAlimeto = item['alimento']['id'];
                  String nombre = item['alimento']['nombre'];
                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: const Color.fromARGB(255, 18, 18, 18),
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
                            child: ViewFoodPage(
                              id: idAlimeto,
                              buttons: false,
                            ),
                          );
                        },
                      );
                    },
                    key: ValueKey(idAlimeto),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 83, 83, 83),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Alimento: $nombre',
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
                    final item = _alimento.removeAt(oldIndex);
                    _alimento.insert(newIndex, item);
                  });
                },
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              _mostrarSeleccionarAlimento();
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              height: 75,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 18, 18, 18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 0.5),
              ),
              child: const Center(
                child: Text(
                  'Agregar un alimento',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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

  Future<void> _loadAlimentoSelect() async {
    print(widget.alimentoId);
    try {
      if (widget.alimentoId != null) {
        final alimento =
            await FoodService.obtenerAlimentoPorId(context, widget.alimentoId!);
        setState(() {
          if (alimento != null) {
            _agregarAlimento(alimento);
            print(alimento);
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

  void _mostrarSeleccionarAlimento() async {
    final alimento = await showModalBottomSheet(
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
          child: AllAlimentosPage(
            agregar: true,
          ),
        );
      },
    );

    if (alimento != null) {
      _agregarAlimento(alimento);
    }
  }

  void _agregarSerie(Workout rutina) {
    _rutina.add({
      'rutina': {'id': rutina.id, 'nombre': rutina.name}
    });
    setState(() {});
  }

  void _agregarAlimento(Food alimento) {
    _alimento.add({
      'alimento': {'id': alimento.id, 'nombre': alimento.name}
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
              if (widget.tipo == "Rutina") {
                _rutina.remove(item);
              } else if (widget.tipo == "Alimento") {
                _alimento.remove(item);
              }

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
    if (_nombreController == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    if (_selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione un color')),
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

    if (widget.tipo == "Rutina") {
      if (_rutina.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una rutina')),
        );
        return;
      }
      final rutina = await RutinaService.obtenerRutinaPorId(
          context, _rutina.first['rutina']['id']);

      Reminder reminder = Reminder(
          //day: _getDayOfWeek(_currentDate),
          modelo: tipoModelo,
          workoutID: _rutina.first['rutina']['id'],
          idRecordar: generateRandomNumber(),
          terminado: false,
          tipo: widget.tipo,
          title: _nombreController.text,
          description: _descripcionController.text,
          color: _selectedColor,
          routineName: rutina?.name,
          primaryFocus: rutina?.primaryFocus,
          secondaryFocus: rutina?.secondaryFocus,
          startTime: combinedStartTime, // Usar la fecha y hora combinadas
          endTime: combinedEndTime, // Usar la fecha y hora combinadas
          repeatDays: _selectedRepeatDays);
     
      final response =
          await ReminderService.createReminder(context, reminder.toJson());

      ReminderScheduler.scheduleReminders(context, reminder, dropdownValue, widget.selectedDate?? DateTime.now());

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
    } else if (widget.tipo == "Alimento") {
      if (_alimento.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona una rutina')),
        );
        return;
      }
      final alimento = await FoodService.obtenerAlimentoPorId(
          context, _alimento.first['alimento']['id']);

      Map<String, dynamic> datosAliemnto = {
        'Proteínas': alimento!.nutrients['Proteínas'] ?? 0,
        'Carbos': alimento.nutrients['Carbos'] ?? 0,
        'Grasas': alimento.nutrients['Grasas'] ?? 0
      };

      Reminder reminder = Reminder(
          //day: _getDayOfWeek(_currentDate),
          modelo: tipoModelo,
          //workoutID: _rutina.first['rutina']['id'],
          idRecordar: generateRandomNumber(),
          terminado: false,
          tipo: widget.tipo,
          datosAliemnto: datosAliemnto,
          title: _nombreController.text,
          description: _descripcionController.text,
          color: _selectedColor,
          dietID: _alimento.first['alimento']['id'],
          startTime: combinedStartTime, // Usar la fecha y hora combinadas
          endTime: combinedEndTime, // Usar la fecha y hora combinadas
          repeatDays: _selectedRepeatDays);
      // print(si);
      final response =
          await ReminderService.createReminder(context, reminder.toJson());
      // ignore: use_build_context_synchronously
      //if (repeatReminder == true) {
      ReminderScheduler.scheduleReminders(context, reminder, dropdownValue, widget.selectedDate?? DateTime.now());
      //}

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
    } else if (widget.tipo == "Recordatorio") {
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
      ReminderScheduler.scheduleReminders(context, reminder, dropdownValue, widget.selectedDate?? DateTime.now());
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
}
