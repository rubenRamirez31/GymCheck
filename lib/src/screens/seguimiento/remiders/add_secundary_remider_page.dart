// ignore_for_file: use_build_context_synchronously
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gym_check/src/models/alimento.dart';
import 'package:gym_check/src/models/reminder_model.dart';
import 'package:gym_check/src/models/workout_model.dart';
import 'package:gym_check/src/screens/seguimiento/calendar/widgets/date_time_selector.dart';
import 'package:gym_check/src/screens/crear/alimentacion/all_alimento_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/all_workout_page.dart';
import 'package:gym_check/src/screens/crear/rutinas/view_workout_page.dart';
import 'package:gym_check/src/screens/principal.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/reminder_scheduler.dart';
import 'package:gym_check/src/screens/seguimiento/tracking_funtions.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/color_menu_widget.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/custom_button.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/days_menu_widget.dart';
import 'package:gym_check/src/screens/seguimiento/widgets/tracking_widgets.dart';
import 'package:gym_check/src/services/food_service.dart';
import 'package:gym_check/src/services/reminder_service.dart';
import 'package:gym_check/src/services/workout_service.dart';
import 'package:intl/intl.dart';

class AddSecondaryReminderPage extends StatefulWidget {
  final DateTime? selectedDate;
  final Map<String, dynamic>? datosRecordatorio;
  final String tipo;
  final bool? update;
  final String? objetoID;

  const AddSecondaryReminderPage({
    Key? key,
    this.selectedDate,
    required this.tipo,
    this.objetoID,
    this.update,
    this.datosRecordatorio,
  }) : super(key: key);

  @override
  _AddSecondaryReminderPageState createState() =>
      _AddSecondaryReminderPageState();
}

class _AddSecondaryReminderPageState extends State<AddSecondaryReminderPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  List<Map<String, dynamic>> _objeto = [];
  DateTime? _startTime;
  DateTime? _endTime;
  Color _selectedColor = Colors.red;
  int dropdownValue = 10;
  bool repeatReminder = false;
  List<int> _selectedRepeatDays =
      []; // Lista de días seleccionados para repetir el recordatorio (1 para Lunes, 2 para Martes, etc.)
  String dayOfWeek = "";
  String formattedDate = "";
  String tipo = "";
  int valcol = 0;
  String nombreApp = "";

  @override
  void initState() {
    super.initState();
    _selectedColor = Colors.red;
    dropdownValue = 10;
    dayOfWeek = _getDayOfWeek(widget.selectedDate ?? DateTime.now());
    formattedDate =
        DateFormat('dd-MM-yyyy').format(widget.selectedDate ?? DateTime.now());
    tipo = widget.tipo;
    nombreApp = "Crear Recordatorio";

    if (widget.update == true) {
      _nombreController.text = widget.datosRecordatorio!['title'] ?? "";
      _descripcionController.text =
          widget.datosRecordatorio!['description'] ?? "";
      _startTime = DateTime.parse(widget.datosRecordatorio!['startTime'] ?? "");
      _endTime = DateTime.parse(widget.datosRecordatorio!['endTime'] ?? "");
      _selectedColor = Color(widget.datosRecordatorio!['color'] ?? 2);
      nombreApp = "Modificar Recordatorio";
      print("asdhkas");
      print(widget.datosRecordatorio!['repeatDays']);
      _selectedRepeatDays =widget.datosRecordatorio!['repeatDays']?.cast<int>() ?? [];
       print("lfjkñamdjñmasdasd");
      print(_selectedRepeatDays);

      if(_selectedRepeatDays.isNotEmpty){
        repeatReminder = true;
      }

     
    }

    _loadObjetoSelect();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C1C2E),
        title: Text(
          nombreApp,
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
               const SizedBox(height: 20.0),
            
              _builObject(),
              const SizedBox(height: 20.0),
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
                  initialDaysNumber: 10,
                  initialSelectedDays: _selectedRepeatDays,
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
              if (widget.update != true)
                CustomButton(
                  onPressed: () {
                    if (_objeto.isEmpty) {
                      TrackingWidgets.showInfo(
                        context,
                        'Error al crear recordatorio',
                        'Debes de agregar un/a ${widget.tipo} antes de crear el recordatorio ;).',
                      );
                    }else
                    if (_formKey.currentState!.validate()) {
                      _addReminder();
                    }
                  },
                  text: 'Agregar',
                  icon: Icons.add_alarm,
                ),
              if (widget.update == true)
                CustomButton(
                  onPressed: () {
                    if (_objeto.isEmpty && widget.tipo != "Recordatorio") {
                      TrackingWidgets.showInfo(
                        context,
                        'Error al crear recordatorio',
                        'Debes de agregar un/a ${widget.tipo} antes de crear el recordatorio ;).',
                      );
                    }else
                    if (_formKey.currentState!.validate()) {
                      _addReminder();
                    }
                  },
                  text: 'Actualizar',
                  icon: Icons.edit,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _builObject() {
    return _objeto.isNotEmpty
        ? Column(
          children: [
              const SizedBox(height: 30.0),
            Container(
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
                    children: _objeto
                        .where((item) => item.containsKey('objeto'))
                        .map((item) {
                      String idObjeto = item['objeto']['id'];
                      String nombre = item['objeto']['nombre'];
                      return GestureDetector(
                        onTap: () {
                          if (widget.tipo == "Rutina") {
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
                                    id: idObjeto,
                                    buttons: false,
                                  ),
                                );
                              },
                            );
                          }
                        },
                        key: ValueKey(idObjeto),
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
                                '${widget.tipo}: $nombre',
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
                        final item = _objeto.removeAt(oldIndex);
                        _objeto.insert(newIndex, item);
                      });
                    },
                  ),
                ),
              ),
          ],
        )
        : GestureDetector(
            onTap: () {
              _mostrarSeleccionarObjeto();
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              height: 75,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 18, 18, 18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 0.5),
              ),
              child: Center(
                child: Text(
                  'Agregar ${widget.tipo}',
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

  Future<void> _loadObjetoSelect() async {
    try {
      if (widget.tipo == "Rutina") {
        final rutina =
            await RutinaService.obtenerRutinaPorId(context, widget.objetoID!);
        setState(() {
          if (rutina != null) {
            _agregarObjeto(rutina);
            print(rutina);
          }
          //_exercise = exercise;
        });
      } else if (widget.tipo == "Alimento") {
        final alimento =
            await FoodService.obtenerAlimentoPorId(context, widget.objetoID!);
        setState(() {
          if (alimento != null) {
            _agregarObjeto(alimento);
            print(alimento);
          }
          //_exercise = exercise;
        });
      }
    } catch (error) {
      print('Error loading exercise: $error');
    }
  }

  void _mostrarSeleccionarObjeto() async {
    Widget pagina;

    switch (widget.tipo) {
      case "Rutina":
        pagina = const FractionallySizedBox(
          heightFactor: 0.90,
          child: AllWorkoutPage(
            agregar: true,
          ),
        );
        break;
      case "Alimento":
        pagina = const FractionallySizedBox(
          heightFactor: 0.90,
          child: AllAlimentosPage(
            agregar: true,
          ),
        );
        break;

      default:
        throw Exception('Opción no válida');
    }

    final objecto = await showModalBottomSheet(
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
        return pagina;
      },
    );
    if (objecto != null) {
      _agregarObjeto(objecto);
    }
  }

  void _agregarObjeto(dynamic objeto) {
    if (objeto is Workout) {
      _agregarRutina(objeto);
    } else if (objeto is Food) {
      _agregarAlimento(objeto);
    } else {
      throw Exception('Tipo de objeto no válido');
    }
  }

  void _agregarRutina(Workout rutina) {
    _objeto.add({
      'objeto': {'id': rutina.id, 'nombre': rutina.name}
    });
    setState(() {});
  }

  void _agregarAlimento(Food alimento) {
    _objeto.add({
      'objeto': {'id': alimento.id, 'nombre': alimento.name}
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
              _objeto.remove(item);

              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }


  int generateRandomNumber() {
    Random random = Random();
    int randomNumber =
        random.nextInt(999999); // Genera un número aleatorio entre 0 y 999999
    return randomNumber;
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

//Todo esto es a la hora de pulsar el boton xd
Future<void> _addReminder() async {
  if (_startTime == null || _endTime == null) {
    _showErrorSnackBar('Por favor ingrese la hora de inicio y fin');
    return;
  }

  if (_startTime!.isAfter(_endTime!)) {
    _showErrorSnackBar('La hora de finalización debe ser después de la hora de inicio');
    return;
  }

  _showCreatingDialog();

  String tipoModelo = repeatReminder ? 'Prime' : 'clon';
  DateTime currentDate = widget.selectedDate ?? DateTime.now();
  DateTime nextSelectedDay = currentDate;

  if (_selectedRepeatDays.isEmpty && widget.selectedDate == null) {
    currentDate = DateTime.now();
  }

  if (widget.selectedDate != null) {
    nextSelectedDay = widget.selectedDate!;
  } else if (_selectedRepeatDays.isNotEmpty) {
    int currentWeekday = nextSelectedDay.weekday;
    int selectedDayIndex = _selectedRepeatDays.firstWhere(
      (dayIndex) => dayIndex >= currentWeekday,
      orElse: () => _selectedRepeatDays.first,
    );

    if (selectedDayIndex != currentWeekday) {
      nextSelectedDay = nextSelectedDay.add(Duration(days: (selectedDayIndex - currentWeekday)));
    }
  }

  DateTime combinedStartTime = _combineDateAndTime(nextSelectedDay, _startTime!);
  DateTime combinedEndTime = _combineDateAndTime(nextSelectedDay, _endTime!);

  Map<String, dynamic> datosObjeto = {};
  if (widget.tipo == 'Rutina') {
    datosObjeto = await _getRutinaData();
  } else if (widget.tipo == 'Alimento') {
    datosObjeto = await _getAlimentoData();
  }

  await _createOrUpdateReminder(
    tipoModelo: tipoModelo,
    combinedStartTime: combinedStartTime,
    combinedEndTime: combinedEndTime,
    datosObjeto: datosObjeto,
  );

  _showSuccessDialog();
}

DateTime _combineDateAndTime(DateTime date, DateTime time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

Future<Map<String, dynamic>> _getRutinaData() async {
  if (_objeto.isEmpty) {
    _showErrorSnackBar('Por favor selecciona una rutina');
    return {};
  }

  final rutina = await RutinaService.obtenerRutinaPorId(context, _objeto.first['objeto']['id']);
  return {
    'primaryFocus': rutina?.primaryFocus,
    'secondaryFocus': rutina?.secondaryFocus,
    'thirdFocus': rutina?.thirdFocus,
    'name': rutina?.name,
  };
}

Future<Map<String, dynamic>> _getAlimentoData() async {
  final alimento = await FoodService.obtenerAlimentoPorId(context, _objeto.first['objeto']['id']);
  return {
    'Proteínas': alimento?.nutrients['Proteínas'] ?? 0,
    'Carbos': alimento?.nutrients['Carbos'] ?? 0,
    'Grasas': alimento?.nutrients['Grasas'] ?? 0,
    'Tipo': alimento?.type,
  };
}

Future<void> _createOrUpdateReminder({
  required String tipoModelo,
  required DateTime combinedStartTime,
  required DateTime combinedEndTime,
  required Map<String, dynamic> datosObjeto,
}) async {
  bool isUpdating = widget.update ?? false;

  if (isUpdating) {
    await ReminderService.deleteReminderIdRecordar(context, widget.datosRecordatorio!['idRecordar']);
  }

  Reminder reminder = Reminder(
    modelo: tipoModelo,
    idRecordar: generateRandomNumber(),
    terminado: false,
    tipo: widget.tipo,
    title: _nombreController.text,
    description: _descripcionController.text,
    color: _selectedColor,
    startTime: combinedStartTime,
    endTime: combinedEndTime,
    repeatDays: _selectedRepeatDays,
    datosObjeto: datosObjeto,
    objetoID: _objeto.first['objeto']['id'],
  );

  final response = await ReminderService.createReminder(context, reminder.toJson());
  ReminderScheduler.scheduleReminders(context, reminder, dropdownValue, widget.selectedDate ?? DateTime.now());

  if (response.containsKey('message')) {
   // _showSuccessSnackBar(response['message']!);
  } else if (response.containsKey('error')) {
    _showErrorSnackBar(response['error']!);
  }

  if (!isUpdating && tipoModelo == 'Prime') {
    Reminder clonedReminder = reminder.clone();
    clonedReminder.modelo = 'clon';
  }
}

void _showCreatingDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          widget.update == true ? 'Actualizando...' : 'Creando...',
          style: TextStyle(color: Colors.white),
        ),
        content: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    },
  );
}

void _showSuccessDialog() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          widget.update == true ? 'Actualizado' : 'Recordatorio creado',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.update == true
                  ? 'El recordatorio ha sido actualizado correctamente.'
                  : 'El recordatorio ha sido almacenado correctamente, y puede encontrarlos en tu calendario.',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const PrincipalPage(
                      initialPageIndex: 2,
                    ),
                  ),
                );
              },
              child: const Text('Aceptar', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    },
  );
}

void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}





}
