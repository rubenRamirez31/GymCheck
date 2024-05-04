import 'package:flutter/material.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_remider_page.dart';

import 'package:intl/intl.dart'; // Importa la biblioteca intl para formatear fechas
import 'package:gym_check/src/screens/calendar/physical-nutritional/create_event_page.dart';

import 'package:gym_check/src/services/reminder_service.dart';

class DayWorkOutDataPage extends StatefulWidget {
  final String day;

  const DayWorkOutDataPage({Key? key, required this.day}) : super(key: key);

  @override
  _DayWorkOutDataPageState createState() => _DayWorkOutDataPageState();
}

class _DayWorkOutDataPageState extends State<DayWorkOutDataPage> {
  List<Map<String, dynamic>> _routines = [];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
       print("Lune");
    //print(_routines);
  }

  Future<void> _loadRoutines() async {
    try {
      //final routines =
       //   await ReminderService.getRemindersByDay(context, widget.day, "Rutina");
      setState(() {
     //   _routines = routines;
      });
       print(_routines);
    } catch (error) {
      print('Error al cargar las rutinas: $error');
    }
  }

  DateTime getNextDayOfWeek(String day) {
  DateTime now = DateTime.now();
  int currentDay = now.weekday;
  int targetDay = DateTime.monday; // Por defecto, establece el día objetivo como lunes

  // Asigna el día objetivo basado en el día proporcionado
  switch (day.toLowerCase()) {
    case 'lunes':
      targetDay = DateTime.monday;
      break;
    case 'martes':
      targetDay = DateTime.tuesday;
      break;
    case 'miércoles':
      targetDay = DateTime.wednesday;
      break;
    case 'jueves':
      targetDay = DateTime.thursday;
      break;
    case 'viernes':
      targetDay = DateTime.friday;
      break;
    case 'sábado':
      targetDay = DateTime.saturday;
      break;
    case 'domingo':
      targetDay = DateTime.sunday;
      break;
    default:
      // Si el día proporcionado no es válido, devuelve la fecha actual
      return now;
  }

  int daysToAdd = targetDay - currentDay;
  if (daysToAdd <= 0) {
    daysToAdd += 7; // Agrega 7 días para obtener la próxima ocurrencia
  }

  return now.add(Duration(days: daysToAdd));
}


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.day),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: screenSize.width,
          child: Column(
            children: _routines.map((routine) {
              return _buildRoutineContainer(
                routine['routineName'],
                routine['primaryFocus'],
                routine['secondaryFocus'],
                routine['startTime'],
                routine['endTime'],

                
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
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
                heightFactor: 0.90,
                child: AddReminderPage(selectedDate: getNextDayOfWeek(widget.day), tipo: "Rutina",),
              );
            },
          );
        },
        icon: Icon(Icons.add),
        label: Text("Agregar Rutina"),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniEndFloat, // Posición del botón flotante
    );
  }

  Widget _buildRoutineContainer(
    String routineName,
    String primaryFocus,
    String secondaryFocus,
    DateTime startTime,
    DateTime endTime,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width - 30,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildRoutineDetailsColumn(
            "Nombre:",
            routineName,
            "Principal:",
            primaryFocus,
            "Enfoque Secundario:",
            secondaryFocus,
            "Hora de inicio:",
            DateFormat('HH:mm').format(startTime), // Formatea la hora de inicio
            "Hora de Fin:",
            DateFormat('HH:mm').format(endTime), // Formatea la hora de fin
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _buildRoutineButtonsColumn(routineName, startTime, endTime),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineDetailsColumn(
    String nameLabel,
    String nameValue,
    String primaryLabel,
    String primaryValue,
    String secondaryLabel,
    String secondaryValue,
    String startTimeLabel,
    String startTimeValue,
    String endTimeLabel,
    String endTimeValue,
  ) {
    return Column(
      children: [
        _buildRoutineDetailsRow(nameLabel, nameValue),
        _buildRoutineDetailsRow(primaryLabel, primaryValue),
        _buildRoutineDetailsRow(secondaryLabel, secondaryValue),
        _buildRoutineDetailsRow(startTimeLabel, startTimeValue),
        _buildRoutineDetailsRow(endTimeLabel, endTimeValue),
      ],
    );
  }

  Widget _buildRoutineDetailsRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(value),
      ],
    );
  }

  Widget _buildRoutineButtonsColumn(String routineName, DateTime startTime, DateTime endTime) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 5,
          height: 5,
        ),

        _buildRoutineButtonWithIcon("Ir A Rutina", Icons.directions_run, () {
          print("Nombre de la rutina seleccionada: $routineName");
        }),
        SizedBox(
          width: 5,
          height: 5,
        ),
        _buildRoutineButtonWithIcon("Recordatorio", Icons.notifications, () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => CreateEventPage(
              //startDate: _startDay,
              startTime: startTime,
              endTime: endTime,
              //Mandar tambien la rutina seleccionada
            ),
          ));
        }),
        SizedBox(
          width: 5,
          height: 5,
        ),
        _buildRoutineButtonWithIcon("Quitar", Icons.delete, () {
          // Acción cuando se presiona "Quitar"
        }),
      ],
    );
  }

  Widget _buildRoutineButtonWithIcon(
      String text, IconData icon, Function() onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
    );
  }
}
