import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';


import 'package:gym_check/src/screens/seguimiento/remiders/add_primary_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/add_secundary_remider_page.dart';
import 'package:gym_check/src/screens/seguimiento/remiders/view_remider_page.dart';

import 'package:gym_check/src/services/reminder_service.dart';


import 'select_day_view_page.dart';

class MonthViewWidget extends StatefulWidget {
  final GlobalKey<MonthViewState>? state;
  final double? width;
  final double cellAspectRatio;

  const MonthViewWidget({
    Key? key,
    this.state,
    this.width,
    required this.cellAspectRatio,
  }) : super(key: key);

  @override
  _MonthViewWidgetState createState() => _MonthViewWidgetState();
}

class _MonthViewWidgetState extends State<MonthViewWidget> {
  late EventController _eventController;
  List<Map<String, dynamic>> _routines = [];
  Map<String, CalendarEventData> _eventMap =
      {}; // Mapa local para asociar IDs con eventos

  @override
  void initState() {
    super.initState();
    _eventController = EventController();

    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    try {
      final routines = await ReminderService.getAllRemindersClon(context);
      setState(() {
        _routines = routines;
      });
      _addEvents(); // Agregar eventos después de cargar las rutinas
    } catch (error) {
      print('Error al cargar las rutinas: $error');
    }
  }

  void _addEvents() {
    // Iterar sobre las rutinas obtenidas y agregar eventos
    _routines.forEach((routine) {
      // Construir el objeto CalendarEventData a partir de la rutina
      CalendarEventData eventData = CalendarEventData(
        title: routine['title'],
        date: routine['startTime'],
        description: routine['description'],
        color: Color(routine['color']),
        startTime: routine['startTime'],
        endTime: routine['endTime'],
      );

      // Agregar el evento al controlador
      _eventController.add(eventData);

      // Asociar el ID del recordatorio con el evento en el mapa local
      _eventMap[routine['id']] = eventData;
      //print(routine);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MonthView(
      key: widget.state,
      width: widget.width,
      cellAspectRatio: widget.cellAspectRatio,


     
      initialMonth: DateTime.now(),
      borderSize: 1,
      controller: _eventController,
      onEventTap: (event, date) {
        // Obtener el ID del evento a partir del mapa local
        String eventId = _eventMap.keys.firstWhere(
          (key) => _eventMap[key] == event,
          orElse: () => '',
        );
        if (eventId.isNotEmpty) {
          showModalBottomSheet(
            //   barrierColor: Colors.black,
            backgroundColor: Colors.black,
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
                heightFactor: 0.60,
                child: ViewReminder(
                  reminderId: eventId,
                ),
              );
            },
          );
        }
      },
     /* onCellTap: (events, date) {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (_) => SelectDayViewPage(selectedDate: date)),
        );
      },*/
      onDateLongPress: (date) => _showOptionsBottomSheet(context, date),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color.fromARGB(255, 18, 18, 18),
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            /*  ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.white),
                title: Text('Ver día', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) =>
                            SelectDayViewPage(selectedDate: selectedDay)),
                  );
                },
              ),*/
              ListTile(
                leading: Icon(Icons.add_alert, color: Colors.white),
                title: Text('Agregar Recordatorio',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPrimaryReminderPage( selectedDate:selectedDay ,
                              tipo: "Recordatorio",
                            )),
                  );
                },
              ),
              ListTile(
                  leading: Icon(Icons.fitness_center, color: Colors.white),
                  title: Text('Agregar Rutina',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddSecondaryReminderPage(selectedDate:selectedDay,
                                tipo: "Rutina",
                              )),
                    );
                  }),
              ListTile(
                leading: Icon(Icons.fastfood, color: Colors.white),
                title: Text('Agregar Comida',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Acción cuando se selecciona "Agregar Comida"
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
